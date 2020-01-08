import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Pupil extends Equatable {
  // Id will be gotten from the database.
  // It's automatically generated & unique for every stored Fruit.
  final String id;
  final String name;

  Pupil({
    @required this.id,
    @required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  /// without ID
  Map<String, dynamic> toMapData() {
    return {
      'name': name,
    };
  }

  String toString() {
    return 'Pupil(${this.toMap().toString()})';
  }

  static Pupil fromMap(String id, Map<String, dynamic> map) {
    var instance = Pupil(
      id: id,
      name: map['name'],
    );
    print('[Pupil.fromMap] ${instance.toString()}');
    return instance;
  }

  @override
  List<Object> get props => [id, name];
}
