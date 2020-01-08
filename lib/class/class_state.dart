import 'package:equatable/equatable.dart';

import 'class.dart';

abstract class ClassState extends Equatable {
  const ClassState();

  @override
  List<Object> get props => [];
}

class ClassLoading extends ClassState {}

class ClassLoaded extends ClassState {
  final List<Class> classes;

  const ClassLoaded(this.classes);

  @override
  List<Object> get props => [classes];
}
