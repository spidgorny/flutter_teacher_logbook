import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'fruit.dart';
import 'fruit_bloc.dart';
import 'fruit_event.dart';
import 'fruit_state.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FruitBloc _fruitBloc;

  @override
  void initState() {
    super.initState();
    // Obtaining the FruitBloc instance through BlocProvider which is an InheritedWidget
    _fruitBloc = BlocProvider.of<FruitBloc>(context);
    // Events can be passed into the bloc by calling dispatch.
    // We want to start loading fruits right from the start.
    _fruitBloc.add(LoadFruits());
  }

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
        child: _buildBody(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _fruitBloc.add(AddRandomFruit());
        },
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<FruitBloc, FruitState>(
//      bloc: _fruitBloc,
      // Whenever there is a new state emitted from the bloc, builder runs.
      builder: (BuildContext context, FruitState state) {
        print('rebuilding...');
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
                subtitle:
                    Text(displayedFruit.isSweet ? 'Very sweet!' : 'Sooo sour!'),
                trailing: _buildUpdateDeleteButtons(displayedFruit),
              );
            },
          );
        } else {
          return Center(child: Text(state.toString()));
        }
      },
    );
  }

  Row _buildUpdateDeleteButtons(Fruit displayedFruit) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            _fruitBloc.add(UpdateWithRandomFruit(displayedFruit));
          },
        ),
        IconButton(
          icon: Icon(Icons.delete_outline),
          onPressed: () {
            _fruitBloc.add(DeleteFruit(displayedFruit));
          },
        ),
      ],
    );
  }
}
