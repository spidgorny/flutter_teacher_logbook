import 'package:sembast/sembast.dart';

import '../app_database.dart';
import '../pupil/pupil.dart';
import 'day.dart';

class DayDao {
  static const String STORE_NAME = 'day';

  final Pupil pupil;

  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Fruit objects converted to Map
  final _dayStore = intMapStoreFactory.store(STORE_NAME);

  DayDao(this.pupil);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  Future<Database> get _db async => await AppDatabase.instance.database;

  Future insert(Day fruit) async {
    var key = await _dayStore.add(await _db, fruit.toMapData());
    print('[DayDao.insert] key: $key');
    return key;
  }

  Future update(Day fruit) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(fruit.id));
    return await _dayStore.update(
      await _db,
      fruit.toMap(),
      finder: finder,
    );
  }

  Future delete(Day me) async {
    print('[dao] delete $me');
    final finder = Finder(filter: Filter.byKey(int.parse(me.id)));
    print('[finder] $finder');
    return await _dayStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future<List<Day>> getAllSortedByName() async {
    // Finder object can also sort data.
    final finder =
        Finder(filter: Filter.equals('pupil', pupil.id), sortOrders: [
      SortOrder('name'),
    ]);

    final recordSnapshots = await _dayStore.find(
      await _db,
      finder: finder,
    );

    // Making a List<Fruit> out of List<RecordSnapshot>
    return recordSnapshots.map((RecordSnapshot snapshot) {
      print('[snapshot] $snapshot');
      return Day.fromMap(snapshot.key.toString(), snapshot.value);
    }).toList();
  }
}
