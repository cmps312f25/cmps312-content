/*
  cascade operator (..) in allows you to perform a series of 
  operations on the same object without having to repeat 
  the object reference for each operation 
*/

class Person {
  String _name = '';
  int _age = 0;

  void setName(String name) {
    this._name = name;
  }

  void setAge(int age) {
    this._age = age;
  }

  void greet() {
    print("Salam, my name is $_name and I am $_age years old.");
  }
}

void main() {
  // Without cascade operator:
  var person1 = Person();
  person1.setName("Ali");
  person1.setAge(20);
  person1.greet();
  
  // With cascade operator:
  var person2 = Person()
    ..setName("Fatima")
    ..setAge(18)
    ..greet();
}
