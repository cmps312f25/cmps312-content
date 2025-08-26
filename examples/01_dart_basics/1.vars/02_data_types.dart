void main() {
  String name = "Ali";
  int age = 19;
  double gpa = 3.5;
  bool isQUStudent = true;

  print('name: $name \nage: $age \ngpa: $gpa \nisQUStudent: $isQUStudent');

  print(
      'name: ${name.runtimeType} \nage: ${age.runtimeType} \ngpa: ${gpa.runtimeType} \nisQUStudent: ${isQUStudent.runtimeType}');
}
