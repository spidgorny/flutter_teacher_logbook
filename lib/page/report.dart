import 'package:date_util/date_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../day/day.dart';
import '../day/day_bloc.dart';
import '../day/day_event.dart';
import '../day/day_state.dart';
import '../day/page.dart';
import '../property/property_bloc.dart';
import '../property/property_state.dart';
import '../pupil/pupil_event.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

import '../class/class.dart';
import '../common/date.dart';
import '../pupil/pupil.dart';
import '../pupil/pupil_bloc.dart';
import '../pupil/pupil_state.dart';

class Report extends StatelessWidget {
  List<Pupil> pupils = [];
  final Class klass;
  final double height = 52;
  final double pupilWidth = 120;
  final double cellWidth = 100;
  final Date month = Date('2020-01-01');
  final List<int> columns = [];

  Report({Key key, @required this.klass}) : super(key: key);

  void generateColumns() {
    var dateUtility = new DateUtil();
    for (int i = 1; i < dateUtility.daysInMonth(month.month, month.year); i++) {
      columns.add(i);
    }
  }

  @override
  Widget build(BuildContext context) {
    this.generateColumns();

    return MultiBlocProvider(
        providers: [
          // already provided in class/page.dart
//          BlocProvider<ClassBloc>(
//              create: (BuildContext context) => ClassBloc()..add(LoadClass())),
          BlocProvider<PupilBloc>(
              create: (BuildContext context) =>
                  PupilBloc(this.klass)..add(LoadPupil())),
//          BlocProvider<PropertyBloc>(
//              create: (BuildContext context) =>
//                  PropertyBloc()..add(LoadProperty())),
        ],
        child: Scaffold(
            appBar: AppBar(
              title: Text('Report for ${klass.name} for ${month.Ym}'),
              actions: <Widget>[
                Builder(
                  builder: (BuildContext context) => IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () {
                      PupilBloc pupilBloc = BlocProvider.of<PupilBloc>(context);
                      pupilBloc.add(LoadPupil());
                    },
                  ),
                )
              ],
            ),
            body: BlocBuilder<PupilBloc, PupilState>(
                builder: (BuildContext context, PupilState state) {
              if (state is PupilLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is PupilLoaded) {
                this.pupils = state.pupils;
                return buildTable(context);
              } else {
                return Center(child: Text('error'));
              }
            })));
  }

  Container buildTable(BuildContext context) {
    return Container(
      child: HorizontalDataTable(
        leftHandSideColumnWidth: this.pupilWidth,
        rightHandSideColumnWidth: this.cellWidth * this.columns.length,
        isFixedHeader: true,
        headerWidgets: this._getHeader(),
        leftSideItemBuilder: _generateFirstColumnRow,
        rightSideItemBuilder: (BuildContext context, int index) =>
            ReportPupilRow(
          pupil: this.pupils[index],
          columns: this.columns,
          month: this.month,
        ),
        itemCount: pupils.length,
        rowSeparatorWidget: const Divider(
          color: Colors.black54,
          height: 1.0,
          thickness: 0.0,
        ),
      ),
      height: MediaQuery.of(context).size.height,
    );
  }

  List<Widget> _getHeader() {
    List<Widget> headers = [this._getTitleItemWidget('Pupil', this.pupilWidth)];
    for (var i in this.columns) {
      headers.add(this._getTitleItemWidget(i.toString(), this.cellWidth));
    }
    return headers;
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
      width: width,
      height: this.height,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      child: Text(pupils[index].name),
      width: this.pupilWidth,
      height: this.height,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }
}

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
