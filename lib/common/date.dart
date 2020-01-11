import 'package:equatable/equatable.dart';

class Date extends Equatable {
  /// YYYY-MM-DD
  final String value;

  Date(this.value);

  Date.today() : value = DateTime.now().toString().substring(0, 10);

  Date.from(DateTime dt) : value = dt.toString().substring(0, 10);

  @override
  List<Object> get props => [value];

  DateTime get toDateTime {
    var parts = value.split('-');
    var year = int.parse(parts[0]);
    var month = int.parse(parts[1]);
    var day = int.parse(parts[2]);
    return DateTime(year, month, day);
  }

  get Ym => this.value.substring(0, 7);

  int get year {
    var parts = value.split('-');
    var year = int.parse(parts[0]);
    return year;
  }

  int get month {
    var parts = value.split('-');
    var month = int.parse(parts[1]);
    return month;
  }

  int get day {
    var parts = value.split('-');
    var day = int.parse(parts[2]);
    return month;
  }
}
