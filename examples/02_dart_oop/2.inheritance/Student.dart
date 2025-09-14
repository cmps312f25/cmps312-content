import 'QuMember.dart';

class Address {
  final String street;
  final String city;

  Address({this.street = '', this.city = ''});
}

class Student extends QuMember {
  final double gpa;
  Address address = Address();

  Student(String firstName, String lastName, DateTime dob, this.gpa)
      : super(firstName, lastName, dob);

  @override
  String toString() => '${super.toString()}. GPA: $gpa';


}
