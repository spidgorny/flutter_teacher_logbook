import 'package:equatable/equatable.dart';

import '../common/date.dart';
import 'day.dart';

abstract class DayState extends Equatable {
  const DayState();

  @override
  List<Object> get props => [];
}

class DayLoading extends DayState {}

class DayLoaded extends DayState {
  final List<Day> days;

  const DayLoaded(this.days);

  @override
  List<Object> get props => [days];

  List<Day> only(Date date) {
    return this.days.where((Day day) {
      return day.day == date.value;
    }).toList();
  }
}
