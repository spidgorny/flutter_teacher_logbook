import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'fruit/fruit.dart';
import 'fruit/fruit_bloc.dart';
import 'fruit/fruit_event.dart';
import 'fruit/fruit_state.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teacher Logbook'),
      ),
      body: BlocListener<FruitBloc, FruitState>(
        listener: (context, state) {
          print('[listener] $state');
        },
        child: BlocBuilder<FruitBloc, FruitState>(
          builder: (BuildContext context, FruitState state) {
            if (state is FruitsLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is FruitsLoaded) {
              return ListView.builder(
                itemCount: state.fruits.length,
                itemBuilder: (context, index) {
                  final displayedFruit = state.fruits[index];
                  return ListTile(
                    title: Text(displayedFruit.name),
                    subtitle: Text(
                      displayedFruit.isSweet ? 'Very sweet!' : 'Sooo sour!',
                    ),
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
          BlocProvider.of<FruitBloc>(context).add(AddRandomFruit());
        },
      ),
    );
  }
}

class FruitButtons extends StatelessWidget {
  final Fruit displayedFruit;

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
            BlocProvider.of<FruitBloc>(context)
                .add(UpdateWithRandomFruit(displayedFruit));
          },
        ),
        IconButton(
          icon: Icon(Icons.delete_outline),
          onPressed: () {
            BlocProvider.of<FruitBloc>(context)
                .add(DeleteFruit(displayedFruit));
          },
        ),
      ],
    );
  }
}
