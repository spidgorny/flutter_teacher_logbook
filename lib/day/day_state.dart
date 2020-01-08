import 'package:equatable/equatable.dart';

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
}
