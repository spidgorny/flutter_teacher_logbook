import 'package:equatable/equatable.dart';

import 'property.dart';

abstract class PropertyState extends Equatable {
  const PropertyState();

  @override
  List<Object> get props => [];
}

class PropertyLoading extends PropertyState {}

class PropertyLoaded extends PropertyState {
  final List<Property> properties;

  const PropertyLoaded(this.properties);

  @override
  List<Object> get props => [properties];

  findByID(int propertyID) {
    for (var prop in properties) {
      if (prop.id == propertyID) {
        return prop;
      }
    }
    return null;
  }
}
