import 'package:flutter/material.dart';
import 'package:flutter_basics/widgets/click_counter.dart';
import 'package:flutter_basics/widgets/flutter_logo.dart';
import 'package:flutter_basics/widgets/greeting.dart';
import 'package:flutter_basics/widgets/hello_world.dart';
import 'package:flutter_basics/screens/welcome_screen.dart';

void main() {
  //runApp(const Greeting(name: "CMPS 312 Students"));
  //runApp(const FlutterLogoScreen());
  runApp(const MainApp());
  //runApp(const WelcomeScreen());
  //runApp(const FlutterLogoScreen());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Flutter Basics')),
        bottomNavigationBar: const BottomAppBar(
          color: Colors.blue,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'CMPS 312 - Flutter Basics',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        body: Center(
          //child: WelcomeScreen(),
          child: ClicksCounter(),
          /* child: Column(
            children: [
              Greeting(name: 'Flutter'),
              SizedBox(height: 16),
              HelloWorld(name: 'CMPS 312 Team'),
              SizedBox(height: 16),
              ClicksCounter()
            ],
          ), */
        ),
      ),
    );
  }
}
