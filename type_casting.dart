/// Type Casting in Dart
main() {
  // String to int
  var one = int.parse('1');
  print("1.");
  print(one);
  print(one.runtimeType);

  // String to double
  var onePointOne = double.parse('1.1');
  print("\n2.");
  print(onePointOne);
  print(onePointOne.runtimeType);

  // int to String
  var twenty = 20.toString();
  print("\n3.");
  print(twenty);
  print(twenty.runtimeType);

  // double to String
  var pi = 3.14316.toStringAsFixed(2);
  print("\n4.");
  print(pi);
  print(pi.runtimeType);
}

/*
OUTPUT:
1.
1
int
2.
1.1
double
3.
20
String
4.
3.14
String
Exited
*/
