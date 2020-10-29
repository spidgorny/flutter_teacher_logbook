import 'dart:core';
import 'dart:io';

import 'package:duration/duration.dart';
import 'package:yaml/yaml.dart';

Future<void> main(List<String> args) async {
  var timeFile = args[0] ?? 'time.yaml';
  // print(timeFile);
  var yaml = await new File(timeFile).readAsString();
  // print(yaml);
  var doc = loadYaml(yaml);
  // print(doc);
  for (YamlMap day in doc) {
    print('Day: ' + day.keys.first);
    var entries = List.from(day[day.keys.first]);
    // print(entries);
    Duration hours = entries.fold(Duration(), (Duration acc, map) {
      var mmap = Map.from(map);
      var dur = parseDuration(mmap.keys.first);
      // print(['-', mmap.keys.first, dur.inMinutes]);
      return acc + dur;
    });
    print(prettyDuration(hours));
  }
}
