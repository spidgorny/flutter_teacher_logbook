import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Property extends Equatable {
  // Id will be gotten from the database.
  // It's automatically generated & unique for every stored Fruit.
  final int id;
  final String name;
  final String icon;

  Property({
    @required this.id,
    @required this.name,
    @required this.icon,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
    };
  }

  /// without ID
  Map<String, dynamic> toMapData() {
    return {
      'name': name,
      'icon': icon,
    };
  }

  String toString() {
    return 'Property(${this.toMap().toString()})';
  }

  static Property fromMap(int id, Map<String, dynamic> map) {
    var instance = Property(
      id: id,
      name: map['name'],
      icon: map['icon'],
    );
    print('[Property.fromMap] ${instance.toString()}');
    return instance;
  }

  @override
  List<Object> get props => [id, name, icon];
}
