import 'package:base_bloc/base_bloc.dart';

import '../presentation/presentation.dart';
import 'class_actions.dart';
import 'class_state.dart';

class ClassBloc extends BaseBloc {
  BlocController<ClassState, Action> get controller => _core;
  BlocCore<ClassState, ClassStateBuilder, Action> _core;

  ClassBloc() {
    _core = BlocCore<ClassState, ClassStateBuilder, Action>(
      stateBuilderInitializer: _initializeStateBuilder,
      stateInitializer: _initializeState,
      dispatcher: _dispatch,
    );
  }

  void dispose() {
    _core.dispose();
  }

  ClassStateBuilder _initializeStateBuilder() {
    return ClassStateBuilder();
  }

  ClassState _initializeState(ClassStateBuilder builder) {
    return builder.build();
  }

  void _dispatch(Action action) {
    switch (action.runtimeType) {
      default:
        assert(false);
    }
  }

  @override
  // TODO: implement initialState
  BaseState get initialState => null;

  @override
  Stream<BaseState> mapEventToState(BaseEvent event) {
    // TODO: implement mapEventToState
    return null;
  }
}
