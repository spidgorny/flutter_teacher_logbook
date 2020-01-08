import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Pupil extends Equatable {
  // Id will be gotten from the database.
  // It's automatically generated & unique for every stored Fruit.
  final String id;
  final String name;
  final String klass;

  Pupil({
    @required this.id,
    @required this.name,
    @required this.klass,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'class': klass,
    };
  }

  /// without ID
  Map<String, dynamic> toMapData() {
    return {
      'name': name,
      'class': klass,
    };
  }

  String toString() {
    return 'Pupil(${this.toMap().toString()})';
  }

  static Pupil fromMap(String id, Map<String, dynamic> map) {
    var instance = Pupil(
      id: id,
      name: map['name'],
      klass: map['class'],
    );
    print('[Pupil.fromMap] ${instance.toString()}');
    return instance;
  }

  @override
  List<Object> get props => [id, name, klass];
}
