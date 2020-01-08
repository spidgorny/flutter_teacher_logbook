import 'package:equatable/equatable.dart';

import 'fruit.dart';

abstract class FruitEvent extends Equatable {
  const FruitEvent();

  @override
  List<Object> get props => [];
}

class LoadFruits extends FruitEvent {}

class AddRandomFruit extends FruitEvent {}

class UpdateWithRandomFruit extends FruitEvent {
  final Fruit updatedFruit;

  const UpdateWithRandomFruit(this.updatedFruit);

  @override
  List<Object> get props => [updatedFruit];
}

class DeleteFruit extends FruitEvent {
  final Fruit fruit;

  const DeleteFruit(this.fruit);

  @override
  List<Object> get props => [fruit];
}
