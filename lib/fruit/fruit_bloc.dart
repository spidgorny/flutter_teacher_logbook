import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';

import 'fruit.dart';
import 'fruit_dao.dart';
import 'fruit_event.dart';
import 'fruit_state.dart';

class FruitBloc extends Bloc<FruitEvent, FruitState> {
  FruitDao _fruitDao = FruitDao();

  // Display a loading indicator right from the start of the app
  @override
  FruitState get initialState => FruitsLoading();

  // This is where we place the logic.
  @override
  Stream<FruitState> mapEventToState(
    FruitEvent event,
  ) async* {
    if (event is LoadFruits) {
      // Indicating that fruits are being loaded - display progress indicator.
      yield FruitsLoading();
      yield* _reloadFruits();
    } else if (event is AddRandomFruit) {
      // Loading indicator shouldn't be displayed while adding/updating/deleting
      // a single Fruit from the database - we aren't yielding FruitsLoading().
      await _fruitDao.insert(RandomFruitGenerator.getRandomFruit());
      yield* _reloadFruits();
    } else if (event is UpdateWithRandomFruit) {
      final newFruit = RandomFruitGenerator.getRandomFruit();
      await _fruitDao.update(newFruit);
      yield* _reloadFruits();
    } else if (event is DeleteFruit) {
      await _fruitDao.delete(event.fruit);
      yield* _reloadFruits();
    }
  }

  Stream<FruitState> _reloadFruits() async* {
    final fruits = await _fruitDao.getAllSortedByName();
    print('State: FruitsLoaded, ${fruits.length}');
    // Yielding a state bundled with the Fruits from the database.
    yield FruitsLoaded(fruits);
  }
}

class RandomFruitGenerator {
  static final _names = [
    'Banana',
    'Strawberry',
    'Kiwi',
    'Apple',
    'Pear',
    'Lemon',
  ];

  static Fruit getRandomFruit() {
    final name = _names[Random().nextInt(5)];
    return Fruit(
      id: Random().nextInt(1000),
      name: name,
      isSweet: Random().nextBool(),
    );
  }
}
