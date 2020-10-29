import 'dart:core';
import 'dart:io';

import 'package:date_calendar/date_calendar.dart';
import 'package:duration/duration.dart';
import 'package:yaml/yaml.dart';

const dow = ['00', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

Future<void> main(List<String> args) async {
  var timeFile = args[0] ?? 'time.yaml';
  // print(timeFile);
  var yaml = await new File(timeFile).readAsString();
  // print(yaml);
  var doc = loadYaml(yaml);
  // print(doc);
  var perDay = getSumHoursPerDay(doc);

  print('Current week (daily):');
  var g = GregorianCalendar.now();
  var monday = g.addDays(-(g.weekday - 1)); // monday
  for (int i = 0; i < 7; i++) {
    var day = monday.addDays(i);
    var weekDay = dow[day.weekday];
    final hours = perDay[day] != null ? prettyDuration(perDay[day]) : '-';
    print([day.toString(), weekDay, hours]);
  }

  print('');
  print('Current month (weekly):');
  var first = GregorianCalendar(g.year, g.month, 1);
  Map<int, Duration> weeks = {};
  for (int i = 0; i < first.monthLength; i++) {
    var day = first.addDays(i);
    if (perDay[day] != null) {
      var weekNr = weekNumber(day);
      var hours = weeks[weekNr] ?? Duration();
      weeks[weekNr] = hours + perDay[day];
    }
  }

  for (int weekNr in weeks.keys) {
    print(['W' + weekNr.toString(), prettyDuration(weeks[weekNr])]);
  }
}

Map<Calendar, Duration> getSumHoursPerDay(YamlList doc) {
  Map<Calendar, Duration> map = {};
  for (YamlMap day in doc) {
    // print('Day: ' + day.keys.first);
    var entries = List.from(day[day.keys.first]);
    // print(entries);
    Duration hours = entries.fold(Duration(), (Duration acc, map) {
      var mmap = Map.from(map);
      var dur = parseDuration(mmap.keys.first);
      // print(['-', mmap.keys.first, dur.inMinutes]);
      return acc + dur;
    });
    //print(prettyDuration(hours));
    var dt = DateTime.parse(day.keys.first);
    map[GregorianCalendar.fromDateTime(dt)] = hours;
  }
  return map;
}

/// https://stackoverflow.com/questions/49393231/how-to-get-day-of-year-week-of-year-from-a-datetime-dart-object
int weekNumber(Calendar date) {
  return ((date.dayOfYear - date.weekday + 10) / 7).floor();
}
