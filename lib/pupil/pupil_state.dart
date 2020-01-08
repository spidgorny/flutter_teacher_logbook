library pupil_state.dart_state;

import 'package:base_bloc/base_bloc.dart';

import '../presentation/presentation.dart';

abstract class PupilState implements BaseState {
  PupilState._();

  factory PupilState([updates(PupilStateBuilder b)]) = _$PupilState;
}
