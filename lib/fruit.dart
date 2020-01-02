import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Fruit extends Equatable {
  // Id will be gotten from the database.
  // It's automatically generated & unique for every stored Fruit.
  final int id;
  final String name;
  final bool isSweet;

  Fruit({
    @required this.id,
    @required this.name,
    @required this.isSweet,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isSweet': isSweet,
    };
  }

  static Fruit fromMap(int id, Map<String, dynamic> map) {
    return Fruit(
      id: id,
      name: map['name'],
      isSweet: map['isSweet'],
    );
  }

  @override
  List<Object> get props => [id, name, isSweet];
}
