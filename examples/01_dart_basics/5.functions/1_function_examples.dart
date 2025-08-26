// Functions in Dart
// Functions are a set of statements that perform a specific task.
// Functions organize the code and make it reusable.
int add(int a, int b) {
  return a + b;
}

int subtract(int a, int b) => a - b;
int multiply(int a, int b) => a * b;
double divide(int a, int b) => a / b;

void saySalam(String name, int age){
  print("Salamou Aleikoum ${name}, you are ${age}");
}

void main() {

 // Write simple pratical function example
  print('result: ${add(5, 2)}');
  print('result: ${subtract(5, 2)}');
  print('result: ${multiply(5, 2)}');
  print('result: ${divide(5, 2)}');

  saySalam("Ali", 18);
  saySalam("Fatima", 22);

}
