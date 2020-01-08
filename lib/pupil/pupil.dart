import 'package:base_bloc/base_bloc.dart';
import 'package:flutter/material.dart';

import './pupil_bloc.dart';
import './pupil_state.dart';

/// Created by DEPIDSVY on 08/Jan/2020
///
/// Copyright ©2020 by DEPIDSVY. All rights reserved.
class PupilWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PupilWidgetState();
}

class PupilWidgetState extends BaseBlocState<PupilWidget> {
  BuildContext _context;

  @override
  Widget build(BuildContext context) =>
      BaseBlocBuilder<PupilState>(bloc, _buildBody);

  @override
  BaseBloc createBloc() => PupilBloc();

  Widget _buildBody(BuildContext context, PupilState state) {
    return SafeArea(
        bottom: false,
        top: false,
        child: Scaffold(
          body: Builder(builder: (BuildContext context) {
            _context = context;
            return Container(
              child: Center(
                child: Text("Pupil Widget"),
              ),
            );
          }),
        ));
  }
}
