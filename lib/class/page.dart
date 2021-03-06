import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../pupil/page.dart';
import '../widget/appbar.dart';
import '../widget/input_dialog.dart';
import 'class.dart';
import 'class_bloc.dart';
import 'class_event.dart';
import 'class_state.dart';

class ClassPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: ClassList(),
      floatingActionButton: ClassFAB(),
    );
  }
}

class ClassFAB extends StatelessWidget {
  const ClassFAB({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () async {
        final InputDialog dialog = new InputDialog(context);
        final String name = await dialog.asyncInputDialog();
        if (name != null && name.isNotEmpty) {
          BlocProvider.of<ClassBloc>(context).add(AddClass(Class(name: name)));
        }
      },
    );
  }
}

class ClassList extends StatelessWidget {
  const ClassList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<ClassBloc, ClassState>(listener: (context, state) {
      print('[listener] $state');
    }, child: BlocBuilder<ClassBloc, ClassState>(
      builder: (BuildContext context, ClassState state) {
        if (state is ClassLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is ClassLoaded) {
          return ListView.builder(
            itemCount: state.classes.length,
            itemBuilder: (context, index) {
              final Class displayedClass = state.classes[index];
              return ListTile(
                title: Text(displayedClass.name ??
                    '' + ' [' + displayedClass.id.toString() + ']'),
                trailing: ClassButtons(displayedClass: displayedClass),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PupilPage(displayedClass)),
                  );
                },
              );
            },
          );
        } else {
          return Center(child: Text(state.toString()));
        }
      },
    ));
  }
}

class ClassButtons extends StatelessWidget {
  final Class displayedClass;

  final bool dangerous = false;

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
          onPressed: dangerous
              ? () {
                  BlocProvider.of<ClassBloc>(context)
                      .add(DeleteClass(displayedClass));
                }
              : null,
        ),
      ],
    );
  }
}
