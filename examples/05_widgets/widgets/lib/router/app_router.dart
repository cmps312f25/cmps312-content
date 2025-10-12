import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:widgets/screens/click_counter.dart';
import 'package:widgets/screens/counter_screen.dart';
import 'package:widgets/screens/tip_calculator.dart';
import 'package:widgets/screens/lift_state_up.dart';
import 'package:widgets/widget_demos/greeting.dart';
import 'package:widgets/widget_demos/button_screen.dart';
import 'package:widgets/widget_demos/text_field_screen.dart';
import 'package:widgets/widget_demos/check_box_screen.dart';
import 'package:widgets/widget_demos/dropdown_screen.dart';
import 'package:widgets/widget_demos/radio_button_screen.dart';
import 'package:widgets/widget_demos/segmented_button_screen.dart';
import 'package:widgets/widget_demos/slider_screen.dart';
import 'package:widgets/widget_demos/switch_screen.dart';
import 'package:widgets/layout_demos/artist_card_screen.dart';
import 'package:widgets/layout_demos/responsive_screen.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      // Widget Demos
      GoRoute(
        path: '/greeting',
        builder: (context, state) => Scaffold(
          appBar: AppBar(title: const Text('Greeting Demo')),
          body: const Center(child: Greeting(name: 'Flutter User')),
        ),
      ),
      GoRoute(
        path: '/button',
        builder: (context, state) => const ButtonScreen(),
      ),
      GoRoute(
        path: '/text-field',
        builder: (context, state) => const TextFieldScreen(),
      ),
      GoRoute(
        path: '/checkbox',
        builder: (context, state) => const CheckBoxScreen(),
      ),
      GoRoute(
        path: '/dropdown',
        builder: (context, state) => const DropdownMenuScreen(),
      ),
      GoRoute(
        path: '/radio-button',
        builder: (context, state) => const RadioButtonScreen(),
      ),
      GoRoute(
        path: '/segmented-button',
        builder: (context, state) => const SegmentedButtonScreen(),
      ),
      GoRoute(
        path: '/slider',
        builder: (context, state) => const SliderScreen(),
      ),
      GoRoute(
        path: '/switch',
        builder: (context, state) => const SwitchScreen(),
      ),
      // Screen Demos
      GoRoute(
        path: '/click-counter',
        builder: (context, state) => const ClickCounterScreen(),
      ),
      GoRoute(
        path: '/counter',
        builder: (context, state) => const CounterScreen(),
      ),
      GoRoute(
        path: '/tip-calculator',
        builder: (context, state) => const TipCalculator(),
      ),
      GoRoute(
        path: '/lift-state',
        builder: (context, state) => const HelloScreen(),
      ),
      // Layout Demos
      GoRoute(
        path: '/artist-card',
        builder: (context, state) => const ArtistCardScreen(),
      ),
      GoRoute(
        path: '/responsive',
        builder: (context, state) => const ResponsiveScreen(),
      ),
    ],
  );

  static GoRouter get router => _router;
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Widget Demos'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildSection(context, 'Widget Demos', Icons.widgets, [
              _MenuItem('Greeting Widget', '/greeting', Icons.waving_hand),
              _MenuItem('Buttons', '/button', Icons.smart_button),
              _MenuItem('Text Fields', '/text-field', Icons.text_fields),
              _MenuItem('Checkboxes', '/checkbox', Icons.check_box),
              _MenuItem('Dropdown Menu', '/dropdown', Icons.arrow_drop_down),
              _MenuItem(
                'Radio Buttons',
                '/radio-button',
                Icons.radio_button_checked,
              ),
              _MenuItem(
                'Segmented Button',
                '/segmented-button',
                Icons.view_week,
              ),
              _MenuItem('Sliders', '/slider', Icons.tune),
              _MenuItem('Switches', '/switch', Icons.toggle_on),
            ]),
            const SizedBox(height: 24),
            _buildSection(context, 'Interactive Screens', Icons.touch_app, [
              _MenuItem('Click Counter', '/click-counter', Icons.add_circle),
              _MenuItem('Counter Screen', '/counter', Icons.exposure_plus_1),
              _MenuItem('Tip Calculator', '/tip-calculator', Icons.calculate),
              _MenuItem(
                'State Lifting Demo',
                '/lift-state',
                Icons.arrow_upward,
              ),
            ]),
            const SizedBox(height: 24),
            _buildSection(context, 'Layout Demos', Icons.dashboard, [
              _MenuItem('Artist Card', '/artist-card', Icons.person),
              _MenuItem('Responsive Layout', '/responsive', Icons.devices),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    IconData icon,
    List<_MenuItem> items,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...items.map((item) => _buildMenuItem(context, item)),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, _MenuItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: Icon(
          item.icon,
          color: Theme.of(context).colorScheme.secondary,
        ),
        title: Text(item.title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => context.push(item.route),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        tileColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}

class _MenuItem {
  final String title;
  final String route;
  final IconData icon;

  const _MenuItem(this.title, this.route, this.icon);
}
