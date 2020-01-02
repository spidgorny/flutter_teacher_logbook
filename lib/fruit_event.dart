import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'fruit.dart';

@immutable
abstract class FruitEvent extends Equatable {
  FruitEvent() : super() {
//    print('FruitEvent');
  }

  @override
  List<Object> get props => [];
}

class LoadFruits extends FruitEvent {}

class AddRandomFruit extends FruitEvent {
  AddRandomFruit() : super() {
    print('AddRandomFruit');
  }
}

class UpdateWithRandomFruit extends FruitEvent {
  final Fruit updatedFruit;

  UpdateWithRandomFruit(this.updatedFruit) : super() {
    print('UpdateWithRandomFruit');
  }

  @override
  List<Object> get props => [updatedFruit];
}

class DeleteFruit extends FruitEvent {
  final Fruit fruit;

  DeleteFruit(this.fruit) : super() {
    print('DeleteFruit');
  }

  @override
  List<Object> get props => [fruit];
}
