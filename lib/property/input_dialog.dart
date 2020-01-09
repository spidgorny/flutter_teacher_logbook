import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Serialization/iconDataSerialization.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter_teacher_logbook/property/property.dart';

class PropertyInputDialog {
  final BuildContext context;
  final String title;
  final String label;
  final String hint;

  PropertyInputDialog(this.context,
      {this.title = 'New Class', this.label = 'Name', this.hint = '8A'});

  Future<Property> asyncInputDialog() async {
    Property property;
    return showDialog<Property>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: PickerForm(
              label: label,
              hint: hint,
              onChange: (Property prop) {
                property = prop;
              }),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop(property);
              },
            ),
          ],
        );
      },
    );
  }
}

typedef void PropertyCallback(Property prop);

class PickerForm extends StatefulWidget {
  final String label;
  final String hint;
  final PropertyCallback onChange;

  const PickerForm({Key key, this.label, this.hint, this.onChange})
      : super(key: key);

  @override
  _PickerFormState createState() => _PickerFormState();
}

class _PickerFormState extends State<PickerForm> {
  String teamName = '';
  IconData _icon = Icons.bug_report;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        new Expanded(
            child: new TextField(
          autofocus: true,
          decoration: new InputDecoration(
              labelText: widget.label, hintText: widget.hint),
          onChanged: (value) {
            setState(() {
              teamName = value;
              widget.onChange(Property(
                  name: teamName, icon: jsonEncode(iconDataToMap(_icon))));
            });
          },
        )),
        IconButton(
          icon: Icon(this._icon),
          onPressed: _pickIcon,
        )
      ],
    );
  }

  _pickIcon() async {
    IconData iconData = await FlutterIconPicker.showIconPicker(context,
        iconSize: 40,
        iconPickerShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title:
            Text('Pick an icon', style: TextStyle(fontWeight: FontWeight.bold)),
        closeChild: Text(
          'Close',
          textScaleFactor: 1.25,
        ),
        searchHintText: 'Search icon...',
        noResultsText: 'No results for:');

    setState(() {
      _icon = iconData;
      widget.onChange(
          Property(name: teamName, icon: jsonEncode(iconDataToMap(_icon))));
    });

    debugPrint('Picked Icon:  $_icon');
  }
}
