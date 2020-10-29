import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart' as pp;
import 'package:platform/platform.dart';

import '../app_database.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  const MyAppBar({Key key, this.title}) : super(key: key);

  @override
  _MyAppBarState createState() => _MyAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.title ?? 'Teacher Logbook'),
      actions: <Widget>[
//        IconButton(
//          icon: Icon(Icons.category),
//          onPressed: () {
//            var event = GlobalEvent.SwitchPageFruit;
//            print('[GlobalEvent emit] $event');
//            streamController.add(event);
//          },
//        ),
//        IconButton(
//          icon: Icon(Icons.assignment_ind),
//          onPressed: () {
//            var event = GlobalEvent.SwitchPageClass;
//            print('[GlobalEvent emit] $event');
//            streamController.add(event);
//          },
//        ),
        IconButton(
          icon: Icon(Icons.control_point_duplicate),
          onPressed: () async {
            await makeBackup();
          },
        ),
      ],
    );
  }

  Future makeBackup() async {
    print('[Backup]');
    var dbPath = await AppDatabase.instance.dbPath;
    print(dbPath);
    File file = File(dbPath);

    Directory extDir;
    Platform _platform = const LocalPlatform();
    if (_platform.isIOS) {
      extDir = await pp.getApplicationDocumentsDirectory();
    } else if (_platform.isAndroid) {
      extDir = await pp.getExternalStorageDirectory();
    } else {
      // web
      return;
    }
    final ymd = DateTime.now().toIso8601String().replaceAll(':', '-');
    final extPath = join(extDir.path, 'teacher-logbook.' + ymd + '.db');
    print(extPath);
    file.copy(extPath);

    Fluttertoast.showToast(
        msg: "Backup is copied to " + extPath,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 15,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
