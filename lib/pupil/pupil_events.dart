import 'package:base_bloc/base_bloc.dart';
import 'package:meta/meta.dart';

/// Created by DEPIDSVY on 08/Jan/2020
///
/// Copyright ©2020 by DEPIDSVY. All rights reserved.
@immutable
class PupilEvent extends BaseEvent {
  final String name;

  PupilEvent(this.name);

  @override
  List<Object> get props => [name];
}
