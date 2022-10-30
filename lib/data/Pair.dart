// Create a pair class
import 'dart:convert';

class Pair<T1, T2> {
  final T1 value1;
  final T2 value2;

  Pair(this.value1, this.value2);
  // Create a method to convert the pair to a map
  Map<T1, T2> toMap() {
    return {value1: value2};
  }

  // Create a method to convert the pair to a json
  String toJson() {
    return jsonEncode(toMap());
  }

  // Create a method to convert the pair to a string
  String toString() {
    return 'Pair(value1: $value1, value: $value2)';
  }
}
