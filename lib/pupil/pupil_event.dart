import 'package:equatable/equatable.dart';

import 'pupil.dart';

abstract class PupilEvent extends Equatable {
  const PupilEvent();

  @override
  List<Object> get props => [];
}

class LoadPupil extends PupilEvent {}

class AddPupil extends PupilEvent {
  final int id;
  final String name;
  final int klass;

  AddPupil(this.name, this.klass, {this.id});
}

class UpdatePupil extends PupilEvent {
  final Pupil me;

  const UpdatePupil(this.me);

  @override
  List<Object> get props => [me];
}

class DeletePupil extends PupilEvent {
  final Pupil me;

  const DeletePupil(this.me);

  @override
  List<Object> get props => [me];
}
