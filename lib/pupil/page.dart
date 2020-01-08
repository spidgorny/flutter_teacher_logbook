import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../class/class.dart';
import '../widget/appbar.dart';
import '../widget/input_dialog.dart';
import 'pupil.dart';
import 'pupil_bloc.dart';
import 'pupil_event.dart';
import 'pupil_state.dart';

class PupilPage extends StatelessWidget {
  final Class klass;

  const PupilPage(this.klass, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => PupilBloc(klass)..add(LoadPupil()),
        child: Scaffold(
          appBar: MyAppBar(title: klass.name),
          body: PupilList(),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () async {
              final InputDialog dialog = new InputDialog(context,
                  title: 'New Pupil', hint: 'Max Musterman');
              final String name = await dialog.asyncInputDialog();
              if (name != null && name.isNotEmpty) {
                BlocProvider.of<PupilBloc>(context)
                    .add(AddPupil(name, int.parse(klass.id)));
              }
            },
          ),
        ));
  }
}

class PupilList extends StatelessWidget {
  const PupilList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<PupilBloc, PupilState>(
      listener: (context, state) {
        print('[listener] $state');
      },
      child: BlocBuilder<PupilBloc, PupilState>(
        builder: (BuildContext context, PupilState state) {
          if (state is PupilLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is PupilLoaded) {
            return ListView.builder(
              itemCount: state.pupils.length,
              itemBuilder: (context, index) {
                final displayedPupil = state.pupils[index];
                return ListTile(
                  title: Text(displayedPupil.name ??
                      '' + ' [' + displayedPupil.id.toString() + ']'),
                  trailing: PupilButtons(displayedPupil: displayedPupil),
                );
              },
            );
          } else {
            return Center(child: Text(state.toString()));
          }
        },
      ),
    );
  }
}

class PupilButtons extends StatelessWidget {
  final Pupil displayedPupil;

  final bool dangerous = false;

  const PupilButtons({Key key, @required this.displayedPupil})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
//        IconButton(
//          icon: Icon(Icons.refresh),
//          onPressed: () {
//            BlocProvider.of<PupilBloc>(context)
//                .add(UpdatePupil(displayedFruit));
//          },
//        ),
        IconButton(
          icon: Icon(Icons.delete_outline),
          onPressed: dangerous
              ? () {
                  BlocProvider.of<PupilBloc>(context)
                      .add(DeletePupil(displayedPupil));
                }
              : null,
        ),
      ],
    );
  }
}
