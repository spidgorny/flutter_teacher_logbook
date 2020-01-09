import 'package:equatable/equatable.dart';

import 'property.dart';

abstract class PropertyEvent extends Equatable {
  const PropertyEvent();

  @override
  List<Object> get props => [];
}

class LoadProperty extends PropertyEvent {}

class AddProperty extends PropertyEvent {
  final Property me;

  AddProperty(this.me);

  @override
  List<Object> get props => [me];
}

class UpdateProperty extends PropertyEvent {
  final Property me;

  const UpdateProperty(this.me);

  @override
  List<Object> get props => [me];
}

class DeleteProperty extends PropertyEvent {
  final Property me;

  const DeleteProperty(this.me);

  @override
  List<Object> get props => [me];
}
