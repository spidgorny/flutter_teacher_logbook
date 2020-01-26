import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_teacher_logbook/common/date.dart';
import 'package:flutter_teacher_logbook/day/day.dart';
import 'package:flutter_teacher_logbook/day/day_bloc.dart';
import 'package:flutter_teacher_logbook/day/day_event.dart';
import 'package:flutter_teacher_logbook/day/day_state.dart';
import 'package:flutter_teacher_logbook/day/page.dart';
import 'package:flutter_teacher_logbook/property/property_bloc.dart';
import 'package:flutter_teacher_logbook/property/property_state.dart';

class ReportPupilRow extends StatelessWidget {
  final pupil;
  final double cellWidth = 100;
  final double cellHeight = 52;
  final List<int> columns;
  final Date month;

  const ReportPupilRow(
      {Key key,
      @required this.pupil,
      @required this.columns,
      @required this.month})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<DayBloc>(
              create: (BuildContext context) =>
                  DayBloc(this.pupil)..add(LoadDay())),
        ],
        child: BlocBuilder<DayBloc, DayState>(
            builder: (BuildContext context, DayState state) {
          if (state is DayLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is DayLoaded) {
            List<Widget> children = [];
            for (var i in this.columns) {
              var day =
                  Date(this.month.Ym + '-' + i.toString().padLeft(2, '0'));
//              print(day);
              var dayData = state.only(day);
              if (day == Date('2010-01-02')) {
                print(['dayData', dayData.length]);
              }
              children.add(this.generateCell(day, dayData));
            }
            return Row(
              children: children,
            );
          } else {
            return Center(child: Text(state.toString()));
          }
        }));
  }

  Widget generateCell(Date day, List<Day> dayData) {
    return BlocBuilder<PropertyBloc, PropertyState>(
        builder: (BuildContext context, PropertyState state) {
      if (state is PropertyLoading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is PropertyLoaded) {
//        print(['properties', state.properties.length]);
        List<Widget> children = [];
        if (dayData.length > 0) {
          for (var day in dayData) {
            var property = state.findByID(day.property);
            if (property != null) {
              if (property.icon != null) {
                children.add(Icon(property.iconData));
              } else {
                children.add(Text(property.name ?? property.id.toString()));
              }
            } else {
              children.add(Text('?'));
            }
          }
        } else {
          // clickable placeholder
          children.add(Container(
            width: this.cellWidth,
            height: cellHeight,
          ));
        }

        return GestureDetector(
          child: Container(
            child: Row(
              children: children,
            ),
            width: this.cellWidth,
            height: this.cellHeight,
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            alignment: Alignment.centerLeft,
          ),
          behavior: HitTestBehavior.translucent,
          onTap: () async {
            var res = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DayPage(this.pupil, day)));
          },
        );
      } else {
        return Center(child: Text(state.toString()));
      }
    });
  }
}
