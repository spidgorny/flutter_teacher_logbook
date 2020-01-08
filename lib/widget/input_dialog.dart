import 'package:flutter/material.dart';

class InputDialog {
  final BuildContext context;

  InputDialog(this.context);

  Future<String> asyncInputDialog() async {
    String teamName = '';
    return showDialog<String>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('New Class'),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                autofocus: true,
                decoration:
                    new InputDecoration(labelText: 'Name', hintText: '8A'),
                onChanged: (value) {
                  teamName = value;
                },
              ))
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop(teamName);
              },
            ),
          ],
        );
      },
    );
  }
}
