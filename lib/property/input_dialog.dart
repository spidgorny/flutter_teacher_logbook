import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Serialization/iconDataSerialization.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

import 'property.dart';

class PropertyInputDialog {
  final BuildContext context;
  final String title;
  final String label;
  final String hint;

  PropertyInputDialog(this.context,
      {this.title = 'New Class', this.label = 'Name', this.hint = '8A'});

  Future<Property> asyncInputDialog(Property property) async {
    return showDialog<Property>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(16),
          title: Text(title),
          content: PickerForm(
              label: label,
              hint: hint,
              property: property,
              onChange: (Property prop) {
                print('[asyncInputDialog] onChange: $prop');
                property = prop;
                print('[asyncInputDialog] onChange: $property');
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
  final Property property;
  final PropertyCallback onChange;

  const PickerForm(
      {Key key,
      this.label,
      this.hint,
      @required this.onChange,
      @required this.property})
      : super(key: key);

  @override
  _PickerFormState createState() => _PickerFormState();
}

class _PickerFormState extends State<PickerForm> {
  IconData _icon = IconData(Icons.add.codePoint,
      fontFamily: Icons.add.fontFamily,
      fontPackage: Icons.add.fontPackage,
      matchTextDirection: Icons.add.matchTextDirection);
  TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController(text: widget.property.name);
    _icon = widget.property.iconData;
  }

  Property get property {
    String iconJson;
    if (_icon != null) {
      iconJson = jsonEncode(iconDataToMap(_icon));
      print('[PickerForm] icon: $iconJson');
    }
    var prop = Property(
        id: widget.property.id,
        name: textEditingController.text,
        icon: iconJson);
    print('[PickerForm] prop: $prop');
    return prop;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        new Expanded(
            child: new TextField(
          autofocus: true,
          decoration: new InputDecoration(
              labelText: widget.label, hintText: widget.hint),
          controller: textEditingController,
          onEditingComplete: () {
            print([
              'Picker Form',
              'onEditingComplete',
              textEditingController.text
            ]);
          },
          onChanged: (value) {
            print([
              'Picker Form',
              'onChanged',
              value,
              textEditingController.text
            ]);
//            setState(() {
            // update textEditingController???
//            });
            widget.onChange(this.property);
            print(['widget.onChange called']);
          },
        )),
        Container(
          decoration:
              BoxDecoration(border: Border.all(color: Colors.blueAccent)),
          child: FlatButton(
            child: Icon(this._icon),
            onPressed: _pickIcon,
          ),
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
    });
    widget.onChange(this.property);

    debugPrint('Picked Icon:  $_icon');
  }
}
