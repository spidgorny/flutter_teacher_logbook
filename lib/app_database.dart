import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Serialization/iconDataSerialization.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

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
    if (DateTime.now().toIso8601String() == 'never') {
      File removeMe = File(dbPath);
      removeMe.deleteSync();
    }
    return dbPath;
  }

  Future _openDatabase() async {
    var database;
    if (kIsWeb) {
      // var store = intMapStoreFactory.store();
      var factory = databaseFactoryWeb;

      // Open the database
      database = await factory.openDatabase('test');
    } else {
      var dbPath = await this.dbPath;
      database = await databaseFactoryIo.openDatabase(dbPath,
          version: 1, onVersionChanged: seedDB);
    }
    // Any code awaiting the Completer's future will now start executing
    _dbOpenCompleter.complete(database);
  }

  FutureOr seedDB(db, oldVersion, newVersion) async {
    // If the db does not exist, create some data
    if (oldVersion == 0) {
      var klass = intMapStoreFactory.store('class');
      var id = await klass.add(db, {'name': '8A'});
      print(['8A.id', id]);

      var pupil = intMapStoreFactory.store('pupil');
      await pupil.add(db, {'name': 'Victor', 'class': id});
      await pupil.add(db, {'name': 'Maria', 'class': id});
      await pupil.add(db, {'name': 'Nina', 'class': id});
      await pupil.add(db, {'name': 'Max', 'class': id});
      await pupil.add(db, {'name': 'Masha', 'class': id});

      var props = intMapStoreFactory.store('property');
      await props.add(db, {
        'name': 'Note 1',
        'icon': jsonEncode(iconDataToMap(Icons.looks_one))
      });
      await props.add(db, {
        'name': 'Note 2',
        'icon': jsonEncode(iconDataToMap(Icons.looks_two))
      });
      await props.add(db,
          {'name': 'Note 3', 'icon': jsonEncode(iconDataToMap(Icons.looks_3))});
      await props.add(db,
          {'name': 'Note 4', 'icon': jsonEncode(iconDataToMap(Icons.looks_4))});
      await props.add(db,
          {'name': 'Note 5', 'icon': jsonEncode(iconDataToMap(Icons.looks_5))});
      await props.add(db, {
        'name': 'Good work',
        'icon': jsonEncode(iconDataToMap(Icons.plus_one))
      });
      await props.add(db, {
        'name': 'Eat during class',
        'icon': jsonEncode(iconDataToMap(Icons.fastfood))
      });
      await props.add(db, {
        'name': 'Misbehave',
        'icon': jsonEncode(iconDataToMap(Icons.mood_bad))
      });
      await props.add(db,
          {'name': 'Fight', 'icon': jsonEncode(iconDataToMap(Icons.people))});
      await props.add(db, {
        'name': 'Came in late',
        'icon': jsonEncode(iconDataToMap(Icons.directions_walk))
      });
      await props.add(db, {
        'name': 'Too loud',
        'icon': jsonEncode(iconDataToMap(Icons.record_voice_over))
      });
      await props.add(db, {
        'name': 'No homework',
        'icon': jsonEncode(iconDataToMap(Icons.cancel))
      });
      await props.add(db, {
        'name': 'Missing',
        'icon': jsonEncode(iconDataToMap(Icons.location_disabled))
      });
    }
  }
}
