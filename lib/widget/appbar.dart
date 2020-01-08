import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../global.dart';

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
