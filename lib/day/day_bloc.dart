import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_teacher_logbook/pupil/pupil.dart';

import 'day.dart';
import 'day_dao.dart';
import 'day_event.dart';
import 'day_state.dart';

class DayBloc extends Bloc<DayEvent, DayState> {
  final Pupil pupil;
  DayDao _dayDao;

  DayBloc(this.pupil) {
    _dayDao = DayDao(pupil);
  }

  // Display a loading indicator right from the start of the app
  @override
  DayState get initialState => DayLoading();

  // This is where we place the logic.
  @override
  Stream<DayState> mapEventToState(
    DayEvent event,
  ) async* {
    if (event is LoadDay) {
      // Indicating that fruits are being loaded - display progress indicator.
      yield DayLoading();
      yield* _reloadDay();
    } else if (event is AddDay) {
      await _dayDao
          .insert(new Day(id: event.id, day: event.day, pupil: pupil.id));
      yield* _reloadDay();
    } else if (event is UpdateDay) {
      int result = await _dayDao.update(event.me);
      print('[Day.mapEventToState] update result: $result');
      yield* _reloadDay();
    } else if (event is DeleteDay) {
      int result = await _dayDao.delete(event.me);
      print('[Day.mapEventToState] delete result: $result');
      yield* _reloadDay();
    }
  }

  Stream<DayState> _reloadDay() async* {
    final days = await _dayDao.getAllSortedByName();
    print('State: DayLoaded, ${days.length}');
    // Yielding a state bundled with the Fruits from the database.
    yield DayLoaded(days);
  }
}
