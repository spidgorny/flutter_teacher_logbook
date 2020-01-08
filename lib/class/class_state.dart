library class_state;

import '../presentation/presentation.dart';

abstract class ClassState implements Built<ClassState, ClassStateBuilder> {
  ClassState._();

  factory ClassState([updates(ClassStateBuilder b)]) = _$ClassState;
}
