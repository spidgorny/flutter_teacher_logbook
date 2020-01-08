import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../global.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  _MyAppBarState createState() => _MyAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Teacher Logbook'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.category),
          onPressed: () {
            var event = GlobalEvent.SwitchPageFruit;
            print('[GlobalEvent emit] $event');
            streamController.add(event);
          },
        ),
        IconButton(
          icon: Icon(Icons.assignment_ind),
          onPressed: () {
            var event = GlobalEvent.SwitchPageClass;
            print('[GlobalEvent emit] $event');
            streamController.add(event);
          },
        )
      ],
    );
  }
}
