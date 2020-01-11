import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'input_dialog.dart';
import 'property.dart';
import 'property_bloc.dart';
import 'property_event.dart';
import 'property_state.dart';

class PropertyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => PropertyBloc()..add(LoadProperty()),
        child: Scaffold(
          appBar: AppBar(
            title: Text('Select Property'),
          ),
          body: PropertyList(),
          floatingActionButton: PropertyFAB(),
        ));
  }
}

class PropertyFAB extends StatelessWidget {
  const PropertyFAB({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () async {
        final PropertyInputDialog dialog = new PropertyInputDialog(context,
            title: 'New Property', hint: 'Absent, Bad Behavior, Rude');
        final Property property = await dialog.asyncInputDialog(Property());
        if (property != null) {
          BlocProvider.of<PropertyBloc>(context).add(AddProperty(property));
        }
      },
    );
  }
}

class PropertyList extends StatelessWidget {
  const PropertyList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<PropertyBloc, PropertyState>(
        listener: (context, state) {
      print('[listener] $state');
    }, child: BlocBuilder<PropertyBloc, PropertyState>(
      builder: (BuildContext context, PropertyState state) {
        if (state is PropertyLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is PropertyLoaded) {
          return ListView.builder(
            itemCount: state.properties.length,
            itemBuilder: (context, index) {
              final Property displayedProperty = state.properties[index];

              // default
              IconData icon = displayedProperty.iconData;
              return ListTile(
                leading: icon != null ? Icon(icon) : null,
                title: Text((displayedProperty.name ?? '') +
                    ' [' +
                    displayedProperty.id.toString() +
                    ']'),
                trailing: PropertyButtons(displayedProperty: displayedProperty),
                onTap: () {
                  Navigator.pop(context, displayedProperty);
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

class PropertyButtons extends StatelessWidget {
  final Property displayedProperty;

  final bool dangerous = false;

  const PropertyButtons({Key key, @required this.displayedProperty})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () async {
            final PropertyInputDialog dialog = new PropertyInputDialog(context,
                title: 'New Property', hint: 'Absent, Bad Behavior, Rude');
            final Property modifiedProperty =
                await dialog.asyncInputDialog(displayedProperty);
            print('[PropertyButtons] modifiedProperty: $modifiedProperty');
            if (modifiedProperty != null) {
              BlocProvider.of<PropertyBloc>(context)
                  .add(UpdateProperty(modifiedProperty));
            }
          },
        ),
        IconButton(
          icon: Icon(Icons.delete_outline),
          onPressed: dangerous
              ? () {
                  BlocProvider.of<PropertyBloc>(context)
                      .add(DeleteProperty(displayedProperty));
                }
              : null,
        ),
      ],
    );
  }
}
