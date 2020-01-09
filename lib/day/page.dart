import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_teacher_logbook/common/date.dart';
import 'package:flutter_teacher_logbook/pupil/pupil.dart';

import '../widget/input_dialog.dart';
import 'day.dart';
import 'day_bloc.dart';
import 'day_event.dart';
import 'day_state.dart';

class DayPage extends StatefulWidget {
  final Pupil pupil;
  final Date date;

  const DayPage(this.pupil, this.date, {Key key}) : super(key: key);

  @override
  _DayPageState createState() => _DayPageState();
}

class _DayPageState extends State<DayPage> {
  Date date;

  void initState() {
    super.initState();
    date = widget.date;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => DayBloc(widget.pupil)..add(LoadDay()),
        child: Scaffold(
          appBar: AppBar(
//              leading: Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: Text(
//                  widget.pupil.name,
//                  style: TextStyle(fontSize: 18),
//                ),
//              ),
              title: Text(widget.pupil.name, style: TextStyle(fontSize: 18)),
//              bottom: PreferredSize(
//                  preferredSize: const Size.fromHeight(16.0),
//                  child: Text(date.value)),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(date.value),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () {
                    _selectDate(context);
                  },
                )
              ]),
          body: DayList(),
          floatingActionButton: DayFAB(),
        ));
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: date.toDateTime,
        firstDate: DateTime(2020, 1),
        lastDate: DateTime(2101));
    if (picked != null) {
      var pickedDate = new Date.from(picked);

      if (picked != date.toDateTime) {
        setState(() {
          date = pickedDate;
        });
      }
    }
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
