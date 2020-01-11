import 'package:date_util/date_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_teacher_logbook/class/class.dart';
import 'package:flutter_teacher_logbook/class/class_bloc.dart';
import 'package:flutter_teacher_logbook/class/class_event.dart';
import 'package:flutter_teacher_logbook/common/date.dart';
import 'package:flutter_teacher_logbook/pupil/pupil.dart';
import 'package:flutter_teacher_logbook/pupil/pupil_bloc.dart';
import 'package:flutter_teacher_logbook/pupil/pupil_event.dart';
import 'package:flutter_teacher_logbook/pupil/pupil_state.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

class Report extends StatelessWidget {
  List<Pupil> pupils;
  double height = 52;
  Date month = Date('2020-01-01');
  List<int> columns = [];

  void generateColumns() {
    var dateUtility = new DateUtil();
    for (int i = 1; i < dateUtility.daysInMonth(month.month, month.year); i++) {
      columns.add(i);
    }
  }

  @override
  Widget build(BuildContext context) {
    var klass = '8A';
    var klassID = 1;
    var klassObj = Class(id: klassID, name: klass);

    this.generateColumns();

    return MultiBlocProvider(
        providers: [
          BlocProvider<ClassBloc>(
              create: (BuildContext context) => ClassBloc()..add(LoadClass())),
          BlocProvider<PupilBloc>(
              create: (BuildContext context) =>
                  PupilBloc(klassObj)..add(LoadPupil())),
        ],
        child: Scaffold(
            appBar: AppBar(
              title: Text('Report for $klass for ${month.Ym}'),
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
        leftHandSideColumnWidth: 100,
        rightHandSideColumnWidth: 600,
        isFixedHeader: true,
        headerWidgets: this._getHeader(),
        leftSideItemBuilder: _generateFirstColumnRow,
        rightSideItemBuilder: _generateRightHandSideColumnRow,
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
    List<Widget> headers = [this._getTitleItemWidget('Pupil', 50)];
    for (var i in this.columns) {
      headers.add(this._getTitleItemWidget(i.toString(), 50));
    }
    return headers;
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
      width: width,
      height: 56,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      child: Text(pupils[index].name),
      width: 100,
      height: this.height,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return Row(
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              Icon(Icons.notifications_active,
                  color: index % 3 == 0 ? Colors.red : Colors.green),
              Text(index % 3 == 0 ? 'Disabled' : 'Active')
            ],
          ),
          width: 100,
          height: this.height,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text('+001 9999 9999'),
          width: 200,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text('2019-01-01'),
          width: 100,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text('N/A'),
          width: 200,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
      ],
    );
  }
}
