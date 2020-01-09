import 'package:equatable/equatable.dart';

import 'day.dart';

abstract class DayEvent extends Equatable {
  const DayEvent();

  @override
  List<Object> get props => [];
}

class LoadDay extends DayEvent {}

class AddDay extends DayEvent {
  final String id;
  final int pupil;
  final String day;
  final int property;
  final String value;

  AddDay(this.pupil, this.day, this.property, this.value, {this.id});
}

class UpdateDay extends DayEvent {
  final Day me;

  const UpdateDay(this.me);

  @override
  List<Object> get props => [me];
}

class DeleteDay extends DayEvent {
  final Day me;

  const DeleteDay(this.me);

  @override
  List<Object> get props => [me];
}
