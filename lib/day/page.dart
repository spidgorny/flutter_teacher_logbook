import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_teacher_logbook/common/date.dart';
import 'package:flutter_teacher_logbook/property/page.dart';

import '../property/property.dart';
import '../property/property_bloc.dart';
import '../property/property_event.dart';
import '../property/property_state.dart';
import '../pupil/pupil.dart';
import 'day.dart';
import 'day_bloc.dart';
import 'day_event.dart';
import 'day_state.dart';

class DayPage extends StatefulWidget {
  final Pupil pupil;
  final Date day;

  const DayPage(this.pupil, this.day, {Key key}) : super(key: key);

  @override
  _DayPageState createState() => _DayPageState();
}

class _DayPageState extends State<DayPage> {
  Date day;

  void initState() {
    super.initState();
    day = widget.day;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<DayBloc>(
              create: (BuildContext context) =>
                  DayBloc(widget.pupil)..add(LoadDay())),
          BlocProvider<PropertyBloc>(
              create: (BuildContext context) =>
                  PropertyBloc()..add(LoadProperty())),
        ],
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
                  child: Text(day != null ? day.value : ''),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () {
                    _selectDate(context);
                  },
                )
              ]),
          body: DayList(),
          floatingActionButton: DayFAB(widget.pupil, day),
        ));
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: day.toDateTime,
        firstDate: DateTime(2020, 1),
        lastDate: DateTime(2101));
    if (picked != null) {
      var pickedDate = new Date.from(picked);

      if (picked != day.toDateTime) {
        setState(() {
          day = pickedDate;
        });
      }
    }
  }
}

class DayFAB extends StatelessWidget {
  final Pupil pupil;
  final Date day;

  const DayFAB(
    this.pupil,
    this.day, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () async {
        Property property = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PropertyPage()),
        );
        if (property != null) {
          BlocProvider.of<DayBloc>(context).add(AddDay(Day(
              id: null,
              pupil: pupil.id,
              day: day.value,
              property: property.id,
              value: '')));
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
                return this.buildTile(displayedDay);
              },
            );
          } else {
            return Center(child: Text(state.toString()));
          }
        },
      ),
    );
  }

  Widget buildTile(Day displayedDay) {
    return BlocBuilder<PropertyBloc, PropertyState>(
        builder: (BuildContext context, PropertyState state) {
      Property property;
      if (displayedDay.property != null) {
        if (state is PropertyLoading) {
          property = Property(name: displayedDay.property.toString());
        } else if (state is PropertyLoaded) {
          property = state.findByID(displayedDay.property);
        }
      }
      return ListTile(
        leading: property.icon != null ? Icon(property.iconData) : null,
        title: Text(property.name + ' [' + displayedDay.id.toString() + ']'),
        trailing: DayButtons(displayedDay: displayedDay),
        onTap: () {},
      );
    });
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
