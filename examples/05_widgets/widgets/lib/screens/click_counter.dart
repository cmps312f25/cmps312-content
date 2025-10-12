import 'package:flutter/material.dart';

/// A stateless counter widget that notifies parent of count changes
class ClickCounter extends StatelessWidget {
  final int count;
  final VoidCallback onCountChange;
  final String? buttonText;

  const ClickCounter({
    super.key,
    required this.count,
    required this.onCountChange,
    this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: onCountChange,
        child: Text(buttonText ?? "I've been clicked $count times"),
      ),
    );
  }
}

/// A stateful wrapper that manages the counter state
class ClickCounterScreen extends StatefulWidget {
  const ClickCounterScreen({super.key});

  @override
  State<ClickCounterScreen> createState() => _ClickCounterScreenState();
}

class _ClickCounterScreenState extends State<ClickCounterScreen> {
  int _clickCount = 0;

  void _incrementCounter() {
    setState(() {
      _clickCount++;
    });
  }

  void _resetCounter() {
    setState(() {
      _clickCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Click Counter'),
        centerTitle: true,
        actions: [
          if (_clickCount > 0)
            IconButton(
              onPressed: _resetCounter,
              icon: const Icon(Icons.refresh),
              tooltip: 'Reset Counter',
            ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Current Count: $_clickCount',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 32),
          ClickCounter(count: _clickCount, onCountChange: _incrementCounter),
          const SizedBox(height: 16),
          // Example of reusing the same counter widget with different text
          ClickCounter(
            count: _clickCount,
            onCountChange: _incrementCounter,
            buttonText: 'Tap to increment ($_clickCount)',
          ),
        ],
      ),
    );
  }
}
