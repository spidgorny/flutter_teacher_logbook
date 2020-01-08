import 'package:flutter/widgets.dart';

import '../presentation/presentation.dart';
import 'class_actions.dart';
import 'class_bloc.dart';
import 'class_state.dart';

class ClassScreen extends StatefulWidget {
  @override
  _ClassScreenState createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen> {
  ClassBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ClassBloc();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocStreamBuilder<ClassState>(
      controller: _bloc.controller,
      builder: (context, state) {
        return _buildUI(state);
      },
    );
  }

  Widget _buildUI(AlertsState state) {
    return Container();
  }
}
