import 'package:equatable/equatable.dart';

import 'pupil.dart';

abstract class PupilState extends Equatable {
  const PupilState();

  @override
  List<Object> get props => [];
}

class PupilLoading extends PupilState {}

class PupilLoaded extends PupilState {
  final List<Pupil> pupils;

  const PupilLoaded(this.pupils);

  @override
  List<Object> get props => [pupils];
}
