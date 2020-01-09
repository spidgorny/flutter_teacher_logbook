import 'package:equatable/equatable.dart';

import 'class.dart';

abstract class ClassEvent extends Equatable {
  const ClassEvent();

  @override
  List<Object> get props => [];
}

class LoadClass extends ClassEvent {}

class AddClass extends ClassEvent {
  final int id;
  final String name;

  AddClass(this.name, {this.id});
}

class UpdateClass extends ClassEvent {
  final Class me;

  const UpdateClass(this.me);

  @override
  List<Object> get props => [me];
}

class DeleteClass extends ClassEvent {
  final Class me;

  const DeleteClass(this.me);

  @override
  List<Object> get props => [me];
}
