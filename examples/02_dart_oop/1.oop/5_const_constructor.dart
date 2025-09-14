class Point {
  final int x;
  final int y;

  // const constructor must be used with const object creation
  const Point(this.x, this.y);

  @override
  String toString() {
    return 'Point{x: $x, y: $y}';
  }
}

void main() {
  // Const objects are canonicalized (same instance reused)
  // const objects are immutable (cannot be changed)
  // const objects are created at compile time (faster)
  // const can be used with literals (e.g., lists, maps)
  var l1 = const [1, 2, 3];
  var l2 = const [1, 2, 3];
  print('l1.hashCode: ${l1.hashCode}');
  print('l2.hashCode: ${l2.hashCode}');
  print(l2 == l1); // true → same instance reused

  const p1 = Point(1, 2);
  const p2 = Point(1, 2);
  final p3 = Point(1, 2);

  //p1.x = 5;

  print('p1.hasCode: ${p1.hashCode}');
  print('p2.hasCode: ${p2.hashCode}');
  print('p3.hasCode: ${p3.hashCode}');
  print(p1 == p2);

  /*
  Benefits:
    - Saves memory (no duplicate objects).
    - Guarantees immutability (object can’t change).
    - Improves performance (object created at compile time).
  */
/*   const p1 = Point(1, 2);
  const p2 = Point(1, 2);

  print('p1.hasCode: ${p1.hashCode}');
  print('p2.hasCode: ${p2.hashCode}');

  print(identical(p1, p2)); // true → same instance reused */
}
