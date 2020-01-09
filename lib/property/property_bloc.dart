import 'dart:async';

import 'package:bloc/bloc.dart';

import 'property_dao.dart';
import 'property_event.dart';
import 'property_state.dart';

class PropertyBloc extends Bloc<PropertyEvent, PropertyState> {
  PropertyDao _propertyDao = PropertyDao();

  // Display a loading indicator right from the start of the app
  @override
  PropertyState get initialState => PropertyLoading();

  // This is where we place the logic.
  @override
  Stream<PropertyState> mapEventToState(
    PropertyEvent event,
  ) async* {
    if (event is LoadProperty) {
      // Indicating that fruits are being loaded - display progress indicator.
      yield PropertyLoading();
      yield* _reloadProperty();
    } else if (event is AddProperty) {
      await _propertyDao.insert(event.me);
      yield* _reloadProperty();
    } else if (event is UpdateProperty) {
      int result = await _propertyDao.update(event.me);
      print('[Property.mapEventToState] update result: $result');
      yield* _reloadProperty();
    } else if (event is DeleteProperty) {
      int result = await _propertyDao.delete(event.me);
      print('[Property.mapEventToState] delete result: $result');
      yield* _reloadProperty();
    }
  }

  Stream<PropertyState> _reloadProperty() async* {
    final propertys = await _propertyDao.getAllSortedByName();
    print('State: PropertyLoaded, ${propertys.length}');
    // Yielding a state bundled with the Fruits from the database.
    yield PropertyLoaded(propertys);
  }
}
