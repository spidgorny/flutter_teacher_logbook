import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widget/appbar.dart';
import 'class.dart';
import 'class_bloc.dart';
import 'class_event.dart';
import 'class_state.dart';

class ClassPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: BlocListener<ClassBloc, ClassState>(
        listener: (context, state) {
          print('[listener] $state');
        },
        child: BlocBuilder<ClassBloc, ClassState>(
          builder: (BuildContext context, ClassState state) {
            if (state is ClassLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ClassLoaded) {
              return ListView.builder(
                itemCount: state.classes.length,
                itemBuilder: (context, index) {
                  final displayedClass = state.classes[index];
                  return ListTile(
                    title: Text(displayedClass.name ??
                        '' + ' [' + displayedClass.id + ']'),
                    trailing: ClassButtons(displayedClass: displayedClass),
                  );
                },
              );
            } else {
              return Center(child: Text(state.toString()));
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final String name = await _asyncInputDialog(context);
          if (name != null && name.isNotEmpty) {
            BlocProvider.of<ClassBloc>(context).add(AddClass(name));
          }
        },
      ),
    );
  }

  Future<String> _asyncInputDialog(BuildContext context) async {
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

class ClassButtons extends StatelessWidget {
  final Class displayedClass;

  const ClassButtons({Key key, @required this.displayedClass})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
//        IconButton(
//          icon: Icon(Icons.refresh),
//          onPressed: () {
//            BlocProvider.of<ClassBloc>(context)
//                .add(UpdateClass(displayedFruit));
//          },
//        ),
        IconButton(
          icon: Icon(Icons.delete_outline),
          onPressed: () {
            BlocProvider.of<ClassBloc>(context)
                .add(DeleteClass(displayedClass));
          },
        ),
      ],
    );
  }
}
