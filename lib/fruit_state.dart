import 'package:equatable/equatable.dart';

import 'fruit.dart';

abstract class FruitState extends Equatable {
  const FruitState();

  @override
  List<Object> get props => [];
}

class FruitsLoading extends FruitState {}

class FruitsLoaded extends FruitState {
  final List<Fruit> fruits;

  const FruitsLoaded(this.fruits);

  @override
  List<Object> get props => [fruits];
}
