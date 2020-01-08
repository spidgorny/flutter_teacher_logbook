import 'package:bloc/bloc.dart';

import '../presentation/presentation.dart';
import 'pupil_actions.dart';
import 'pupil_events.dart';
import 'pupil_state.dart';

class PupilBloc extends Bloc<PupilEvent, PupilState> {
  BlocController<PupilState, PupilAction> get controller => _core;
  BlocCore<PupilState, PupilStateBuilder, PupilAction> _core;

  PupilBloc() {
    _core = BlocCore<PupilState, PupilStateBuilder, PupilAction>(
      stateBuilderInitializer: _initializeStateBuilder,
      stateInitializer: _initializeState,
      dispatcher: _dispatch,
    );
  }

  void dispose() {
    _core.dispose();
  }

  PupilStateBuilder _initializeStateBuilder() {
    return PupilStateBuilder();
  }

  PupilState _initializeState(PupilStateBuilder builder) {
    return builder.build();
  }

  void _dispatch(PupilAction action) {
    switch (action.runtimeType) {
      default:
        assert(false);
    }
  }

  @override
  // TODO: implement initialState
  get initialState => null;

  @override
  Stream mapEventToState(event) {
    // TODO: implement mapEventToState
    return null;
  }
}
