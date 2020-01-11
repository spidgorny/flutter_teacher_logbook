import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class AppDatabase {
  // Singleton instance
  static final AppDatabase _singleton = AppDatabase._();

  // Singleton accessor
  static AppDatabase get instance => _singleton;

  // Completer is used for transforming synchronous code into asynchronous code.
  Completer<Database> _dbOpenCompleter;

  // A private constructor. Allows us to create instances of AppDatabase
  // only from within the AppDatabase class itself.
  AppDatabase._();

  // Sembast database object
  Database _database;

  // Database object accessor
  Future<Database> get database async {
    // If completer is null, AppDatabaseClass is newly instantiated, so database is not yet opened
    if (_dbOpenCompleter == null) {
      _dbOpenCompleter = Completer();
      // Calling _openDatabase will also complete the completer with database instance
      _openDatabase();
    }
    // If the database is already opened, awaiting the future will happen instantly.
    // Otherwise, awaiting the returned future will take some time - until complete() is called
    // on the Completer in _openDatabase() below.
    return _dbOpenCompleter.future;
  }

  Future get dbPath async {
    // Get a platform-specific directory where persistent app data can be stored
    final appDocumentDir = await getApplicationDocumentsDirectory();
    // Path with the form: /platform-specific-directory/demo.db
    final dbPath = join(appDocumentDir.path, 'demo.db');
    return dbPath;
  }

  Future _openDatabase() async {
    var dbPath = await this.dbPath;
    var database = await databaseFactoryIo.openDatabase(dbPath, version: 1,
        onVersionChanged: (db, oldVersion, newVersion) async {
      // If the db does not exist, create some data
      if (oldVersion == 0) {
        var klass = intMapStoreFactory.store('class');
        await klass.add(db, {'name': '8A'});

        var pupil = intMapStoreFactory.store('class');
        await pupil.add(db, {'name': 'Victor'});
        await pupil.add(db, {'name': 'Maria'});
        await pupil.add(db, {'name': 'Nina'});
        await pupil.add(db, {'name': 'Max'});
        await pupil.add(db, {'name': 'Masha'});

        var props = intMapStoreFactory.store('property');
      }
    });
    // Any code awaiting the Completer's future will now start executing
    _dbOpenCompleter.complete(database);
  }
}
