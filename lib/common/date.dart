import 'package:equatable/equatable.dart';

class Date extends Equatable {
  /// YYYY-MM-DD
  final String value;

  Date(this.value);

  Date.today() : value = DateTime.now().toString().substring(0, 10);

  @override
  // TODO: implement props
  List<Object> get props => [value];
}
