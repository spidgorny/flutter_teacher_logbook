import 'package:equatable/equatable.dart';

import 'class.dart';

abstract class ClassEvent extends Equatable {
  const ClassEvent();

  @override
  List<Object> get props => [];
}

class LoadClass extends ClassEvent {}

class AddClass extends ClassEvent {
  final String id;
  final String name;

  AddClass(this.id, this.name);
}

class UpdateClass extends ClassEvent {
  final Class newClass;

  const UpdateClass(this.newClass);

  @override
  List<Object> get props => [newClass];
}

class DeleteClass extends ClassEvent {
  final Class me;

  const DeleteClass(this.me);

  @override
  List<Object> get props => [me];
}
