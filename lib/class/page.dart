import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'class.dart';
import 'class_bloc.dart';
import 'class_event.dart';
import 'class_state.dart';

class ClassPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teacher Logbook'),
      ),
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
                  final displayedFruit = state.classes[index];
                  return ListTile(
                    title: Text(displayedFruit.name),
                    trailing: FruitButtons(displayedFruit: displayedFruit),
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
        onPressed: () {
          BlocProvider.of<ClassBloc>(context).add(AddClass("123", "test"));
        },
      ),
    );
  }
}

class FruitButtons extends StatelessWidget {
  final Class displayedFruit;

  const FruitButtons({Key key, @required this.displayedFruit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            BlocProvider.of<ClassBloc>(context)
                .add(UpdateClass(displayedFruit));
          },
        ),
        IconButton(
          icon: Icon(Icons.delete_outline),
          onPressed: () {
            BlocProvider.of<ClassBloc>(context)
                .add(DeleteClass(displayedFruit));
          },
        ),
      ],
    );
  }
}
