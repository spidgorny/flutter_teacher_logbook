import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Class extends Equatable {
  // Id will be gotten from the database.
  // It's automatically generated & unique for every stored Fruit.
  final String id;
  final String name;

  Class({
    @required this.id,
    @required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  static Class fromMap(String id, Map<String, dynamic> map) {
    return Class(
      id: id,
      name: map['name'],
    );
  }

  @override
  List<Object> get props => [id, name];
}
