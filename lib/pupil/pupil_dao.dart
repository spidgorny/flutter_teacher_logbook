import 'package:sembast/sembast.dart';

import '../app_database.dart';
import '../class/class.dart';
import 'pupil.dart';

class PupilDao {
  static const String STORE_NAME = 'pupil';

  final Class klass;

  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Fruit objects converted to Map
  final _pupilStore = intMapStoreFactory.store(STORE_NAME);

  PupilDao(this.klass);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  Future<Database> get _db async => await AppDatabase.instance.database;

  Future insert(Pupil me) async {
    var key = await _pupilStore.add(await _db, me.toMapData());
    print('[PupilDao.insert] key: $key');
    return key;
  }

  Future update(Pupil me) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(me.id));
    return await _pupilStore.update(
      await _db,
      me.toMap(),
      finder: finder,
    );
  }

  Future delete(Pupil me) async {
    print('[dao] delete $me');
    final finder = Finder(filter: Filter.byKey(me.id));
    print('[finder] $finder');
    return await _pupilStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future<List<Pupil>> getAllSortedByName() async {
    // Finder object can also sort data.
    final finder =
        Finder(filter: Filter.equals('class', klass.id), sortOrders: [
      SortOrder('name'),
    ]);
    print('[PupilDao.getAll] $finder');

    final recordSnapshots = await _pupilStore.find(
      await _db,
      finder: finder,
    );

    // Making a List<Fruit> out of List<RecordSnapshot>
    return recordSnapshots.map((RecordSnapshot snapshot) {
      print('[snapshot] $snapshot');
      return Pupil.fromMap(snapshot.key, snapshot.value);
    }).toList();
  }
}
