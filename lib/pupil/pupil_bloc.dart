import 'dart:async';

import 'package:bloc/bloc.dart';

import 'pupil.dart';
import 'pupil_dao.dart';
import 'pupil_event.dart';
import 'pupil_state.dart';

class PupilBloc extends Bloc<PupilEvent, PupilState> {
  PupilDao _classDao = PupilDao();

  // Display a loading indicator right from the start of the app
  @override
  PupilState get initialState => PupilLoading();

  // This is where we place the logic.
  @override
  Stream<PupilState> mapEventToState(
    PupilEvent event,
  ) async* {
    if (event is LoadPupil) {
      // Indicating that fruits are being loaded - display progress indicator.
      yield PupilLoading();
      yield* _reloadPupil();
    } else if (event is AddPupil) {
      await _classDao.insert(new Pupil(id: event.id, name: event.name));
      yield* _reloadPupil();
    } else if (event is UpdatePupil) {
      int result = await _classDao.update(event.me);
      print('[Pupil.mapEventToState] update result: $result');
      yield* _reloadPupil();
    } else if (event is DeletePupil) {
      int result = await _classDao.delete(event.me);
      print('[Pupil.mapEventToState] delete result: $result');
      yield* _reloadPupil();
    }
  }

  Stream<PupilState> _reloadPupil() async* {
    final classes = await _classDao.getAllSortedByName();
    print('State: PupilLoaded, ${classes.length}');
    // Yielding a state bundled with the Fruits from the database.
    yield PupilLoaded(classes);
  }
}
