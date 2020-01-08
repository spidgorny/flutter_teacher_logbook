import 'dart:async';

import 'package:bloc/bloc.dart';

import 'class.dart';
import 'class_dao.dart';
import 'class_event.dart';
import 'class_state.dart';

class ClassBloc extends Bloc<ClassEvent, ClassState> {
  ClassDao _classDao = ClassDao();

  // Display a loading indicator right from the start of the app
  @override
  ClassState get initialState => ClassLoading();

  // This is where we place the logic.
  @override
  Stream<ClassState> mapEventToState(
    ClassEvent event,
  ) async* {
    if (event is LoadClass) {
      // Indicating that fruits are being loaded - display progress indicator.
      yield ClassLoading();
      yield* _reloadClass();
    } else if (event is AddClass) {
      // Loading indicator shouldn't be displayed while adding/updating/deleting
      // a single Fruit from the database - we aren't yielding FruitsLoading().
      await _classDao.insert(new Class(id: event.id, name: event.name));
      yield* _reloadClass();
    } else if (event is UpdateClass) {
      await _classDao.update(event.newClass);
      yield* _reloadClass();
    } else if (event is DeleteClass) {
      await _classDao.delete(event.me);
      yield* _reloadClass();
    }
  }

  Stream<ClassState> _reloadClass() async* {
    final classes = await _classDao.getAllSortedByName();
    print('State: ClassLoaded, ${classes.length}');
    // Yielding a state bundled with the Fruits from the database.
    yield ClassLoaded(classes);
  }
}
