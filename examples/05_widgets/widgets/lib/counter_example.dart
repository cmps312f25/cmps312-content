import 'package:flutter/material.dart';
class CounterScreen extends StatefulWidget {
  final int startValue;
  const CounterScreen({super.key, this.startValue = 0});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  late int _counter;

  // 1️⃣ Called once when the state object is created
  @override
  void initState() {
    super.initState();
    _counter = widget.startValue; // initialize state
    print("initState: counter starts at $_counter");
  }

  // 2️⃣ Called if parent widget changes its properties
  @override
  void didUpdateWidget(CounterScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.startValue != widget.startValue) {
      _counter = widget.startValue;
      print("didUpdateWidget: counter reset to $_counter");
    }
  }

  // 3️⃣ Called when dependencies like Theme or MediaQuery change
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("didChangeDependencies: theme or locale changed");
  }

  // 4️⃣ Called whenever setState() is used
  @override
  Widget build(BuildContext context) {
    print("build: rebuilding UI with counter = $_counter");
    return Scaffold(
      appBar: AppBar(title: Text("Counter = $_counter")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              _counter++;
            });
          },
          child: const Text("Increment"),
        ),
      ),
    );
  }

  // 5️⃣ Called when widget is removed permanently
  @override
  void dispose() {
    print("dispose: cleaning up resources");
    super.dispose();
  }
}
