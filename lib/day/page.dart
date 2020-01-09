import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_teacher_logbook/common/date.dart';
import 'package:flutter_teacher_logbook/pupil/pupil.dart';

import '../widget/input_dialog.dart';
import 'day.dart';
import 'day_bloc.dart';
import 'day_event.dart';
import 'day_state.dart';

class DayPage extends StatelessWidget {
  final Pupil pupil;
  final Date date;

  const DayPage(this.pupil, this.date, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => DayBloc(pupil)..add(LoadDay()),
        child: Scaffold(
          appBar: AppBar(title: Text(pupil.name), actions: [
            IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () {
                print('new date');
              },
            )
          ]),
          body: DayList(),
          floatingActionButton: DayFAB(),
        ));
  }
}

class DayFAB extends StatelessWidget {
  const DayFAB({
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
          BlocProvider.of<DayBloc>(context).add(AddDay(name));
        }
      },
    );
  }
}

class DayList extends StatelessWidget {
  const DayList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<DayBloc, DayState>(
      listener: (context, state) {
        print('[listener] $state');
      },
      child: BlocBuilder<DayBloc, DayState>(
        builder: (BuildContext context, DayState state) {
          if (state is DayLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is DayLoaded) {
            return ListView.builder(
              itemCount: state.days.length,
              itemBuilder: (context, index) {
                final Day displayedDay = state.days[index];
                return ListTile(
                  title: Text(
                      displayedDay.name ?? '' + ' [' + displayedDay.id + ']'),
                  trailing: DayButtons(displayedDay: displayedDay),
                  onTap: () {},
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

class DayButtons extends StatelessWidget {
  final Day displayedDay;

  final bool dangerous = false;

  const DayButtons({Key key, @required this.displayedDay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
//        IconButton(
//          icon: Icon(Icons.refresh),
//          onPressed: () {
//            BlocProvider.of<DayBloc>(context)
//                .add(UpdateDay(displayedFruit));
//          },
//        ),
        IconButton(
          icon: Icon(Icons.delete_outline),
          onPressed: dangerous
              ? () {
                  BlocProvider.of<DayBloc>(context)
                      .add(DeleteDay(displayedDay));
                }
              : null,
        ),
      ],
    );
  }
}
