import 'package:flutter/material.dart';

class InputDialog {
  final BuildContext context;
  final String title;
  final String label;
  final String hint;

  InputDialog(this.context,
      {this.title = 'New Class', this.label = 'Name', this.hint = '8A'});

  Future<String> asyncInputDialog({String initialText}) async {
    String teamName = '';
    return showDialog<String>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                controller: TextEditingController()..text = initialText,
                autofocus: true,
                decoration:
                    new InputDecoration(labelText: label, hintText: hint),
                onChanged: (value) {
                  teamName = value;
                },
              ))
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
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
