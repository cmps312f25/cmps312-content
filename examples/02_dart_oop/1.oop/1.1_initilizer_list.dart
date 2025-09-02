class Rectangle {
  final double width;
  final double height;
  final double area;

  // area is pre-computed when the object is created, 
  // so you don’t need to calculate it every time later
  Rectangle(this.width, this.height)
      : area = width * height; // computed before constructor body

  @override
  String toString()  => 'Rectangle: $width x $height, Area = $area';
}

void main() {
  final rect = Rectangle(5, 10);
  print(rect);
}