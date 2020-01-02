import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'fruit.dart';

@immutable
abstract class FruitState extends Equatable {
  @override
  List<Object> get props => [];
}

class FruitsLoading extends FruitState {}

class FruitsLoaded extends FruitState {
  final List<Fruit> fruits;

  FruitsLoaded(this.fruits) : super() {
    print('State: FruitsLoaded');
  }

  @override
  List<Object> get props => [fruits];
}
