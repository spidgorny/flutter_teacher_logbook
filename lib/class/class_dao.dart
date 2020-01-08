import 'package:sembast/sembast.dart';

import '../app_database.dart';
import 'class.dart';

class ClassDao {
  static const String CLASS_STORE_NAME = 'class';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Fruit objects converted to Map
  final _classStore = intMapStoreFactory.store(CLASS_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  Future<Database> get _db async => await AppDatabase.instance.database;

  Future insert(Class fruit) async {
    await _classStore.add(await _db, fruit.toMap());
  }

  Future update(Class fruit) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(fruit.id));
    await _classStore.update(
      await _db,
      fruit.toMap(),
      finder: finder,
    );
  }

  Future delete(Class me) async {
    print('[dao] delete $me');
    final finder = Finder(filter: Filter.byKey(me.id));
    print('[finder] $finder');
    await _classStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future<List<Class>> getAllSortedByName() async {
    // Finder object can also sort data.
    final finder = Finder(sortOrders: [
      SortOrder('name'),
    ]);

    final recordSnapshots = await _classStore.find(
      await _db,
      finder: finder,
    );

    // Making a List<Fruit> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      return Class.fromMap(snapshot.key.toString(), snapshot.value);
    }).toList();
  }
}
