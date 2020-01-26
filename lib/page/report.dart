import 'package:csv/csv.dart';
import 'package:date_util/date_util.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_teacher_logbook/day/day_bloc.dart';
import 'package:flutter_teacher_logbook/day/day_event.dart';
import 'package:flutter_teacher_logbook/day/day_state.dart';
import 'package:flutter_teacher_logbook/page/report_row.dart';
import 'package:flutter_teacher_logbook/property/property_bloc.dart';
import 'package:flutter_teacher_logbook/property/property_event.dart';
import 'package:flutter_teacher_logbook/property/property_state.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

import '../class/class.dart';
import '../common/date.dart';
import '../pupil/pupil.dart';
import '../pupil/pupil_bloc.dart';
import '../pupil/pupil_event.dart';
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
//                IconButton(
//                  icon: Icon(Icons.refresh),
//                  onPressed: () {
//                    PupilBloc pupilBloc = BlocProvider.of<PupilBloc>(context);
//                    pupilBloc.add(LoadPupil());
//                  },
//                ),
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () async {
                    var yourListOfLists = await this.getReportTable(context);
                    String csv =
                        const ListToCsvConverter().convert(yourListOfLists);
                    await Share.file(
                        'TeacherLogbook',
                        'TeacherLogbook-' + this.month.Ym + '.csv',
                        csv.codeUnits,
                        'text/csv',
                        text: 'Pupil Report for ' + this.month.Ym);
                  },
                ),
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

  Future<List<List<String>>> getReportTable(BuildContext context) async {
    var header = ['Pupil'];
    for (var i in this.columns) {
      header.add(i.toString());
    }
    var yourListOfLists = [];
    yourListOfLists.add(header);

    PropertyBloc propertyBloc = BlocProvider.of<PropertyBloc>(context);
    propertyBloc.add(LoadProperty());
    PropertyLoaded properties = await propertyBloc
        .firstWhere((PropertyState state) => state is PropertyLoaded);
    print(['properties', properties.properties]);

    for (var pupil in pupils) {
      var row = [pupil.name];
      for (var i in this.columns) {
        var day = Date(this.month.Ym + '-' + i.toString().padLeft(2, '0'));
        DayBloc dayBloc = BlocProvider.of<DayBloc>(context);
        dayBloc.add(LoadDay());
        DayLoaded dayLoaded =
            await dayBloc.firstWhere((DayState state) => state is DayLoaded);
        var dayData = dayLoaded.only(day);

        for (var day in dayData) {
          var property = properties.findByID(day.property);
          print(['property', property]);
        }
      }
      yourListOfLists.add(row);
    }
    return yourListOfLists;
  }
}
