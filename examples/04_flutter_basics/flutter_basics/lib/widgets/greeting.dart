import 'package:flutter/material.dart';

class Greeting extends StatelessWidget {
  final String name;

  // ignore: use_key_in_widget_constructors
  const Greeting({required this.name});

  @override
  Widget build(BuildContext context) {
    // Example usage of the BuildContext
    final mediaQuery = MediaQuery.of(context);

    return Text(
      'Salam $name!',
      //'Salam $name!\nScreen width: ${mediaQuery.size.width}',
      textDirection: TextDirection.ltr,

      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    );
  }
}
