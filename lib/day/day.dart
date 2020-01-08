import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Day extends Equatable {
  // Id will be gotten from the database.
  // It's automatically generated & unique for every stored Fruit.
  final String id;
  final String name;
  final int pupil;

  Day({
    @required this.id,
    @required this.name,
    @required this.pupil,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'pupil': pupil,
    };
  }

  /// without ID
  Map<String, dynamic> toMapData() {
    return {
      'name': name,
      'pupil': pupil,
    };
  }

  String toString() {
    return 'Day(${this.toMap().toString()})';
  }

  static Day fromMap(String id, Map<String, dynamic> map) {
    var instance = Day(
      id: id,
      name: map['name'],
      pupil: map['pupil'],
    );
    print('[Day.fromMap] ${instance.toString()}');
    return instance;
  }

  @override
  List<Object> get props => [id, name, pupil];
}
