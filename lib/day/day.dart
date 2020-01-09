import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Day extends Equatable {
  // Id will be gotten from the database.
  // It's automatically generated & unique for every stored Fruit.
  final String id;
  final int pupil;
  final String day;
  final int property;
  final String value;

  Day({
    @required this.id,
    @required this.pupil,
    @required this.day,
    @required this.property,
    @required this.value,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pupil': pupil,
      'day': day,
      'property': property,
      'value': value,
    };
  }

  /// without ID
  Map<String, dynamic> toMapData() {
    return {
      'pupil': pupil,
      'day': day,
      'property': property,
      'value': value,
    };
  }

  String toString() {
    return 'Day(${this.toMap().toString()})';
  }

  static Day fromMap(String id, Map<String, dynamic> map) {
    var instance = Day(
      id: id,
      pupil: map['pupil'],
      day: map['day'],
      property: map['property'],
      value: map['value'],
    );
    print('[Day.fromMap] ${instance.toString()}');
    return instance;
  }

  @override
  List<Object> get props => [id, pupil, day, property, value];
}
