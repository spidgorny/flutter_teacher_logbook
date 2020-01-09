import 'package:sembast/sembast.dart';

import '../app_database.dart';
import 'property.dart';

class PropertyDao {
  static const String CLASS_STORE_NAME = 'property';

  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Fruit objects converted to Map
  final _propertyStore = intMapStoreFactory.store(CLASS_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  Future<Database> get _db async => await AppDatabase.instance.database;

  Future insert(Property fruit) async {
    var key = await _propertyStore.add(await _db, fruit.toMapData());
    print('[PropertyDao.insert] key: $key');
    return key;
  }

  Future update(Property fruit) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(fruit.id));
    return await _propertyStore.update(
      await _db,
      fruit.toMap(),
      finder: finder,
    );
  }

  Future delete(Property me) async {
    print('[dao] delete $me');
    final finder = Finder(filter: Filter.byKey(me.id));
    print('[finder] $finder');
    return await _propertyStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future<List<Property>> getAllSortedByName() async {
    // Finder object can also sort data.
    final finder = Finder(sortOrders: [
      SortOrder('name'),
    ]);

    final recordSnapshots = await _propertyStore.find(
      await _db,
      finder: finder,
    );

    // Making a List<Fruit> out of List<RecordSnapshot>
    return recordSnapshots.map((RecordSnapshot snapshot) {
      print('[snapshot] $snapshot');
      return Property.fromMap(snapshot.key, snapshot.value);
    }).toList();
  }
}
