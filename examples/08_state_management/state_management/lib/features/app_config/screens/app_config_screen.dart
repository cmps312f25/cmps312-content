import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management/features/app_config/providers/app_config_provider.dart';
import 'package:state_management/features/app_config/providers/max_items_per_page_provider.dart';
import 'package:state_management/features/app_config/providers/theme_mode_provider.dart';

class AppConfigScreen extends ConsumerWidget {
  const AppConfigScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Reading configuration from providers
    final apiConfig = ref.watch(apiConfigProvider);
    final maxItems = ref.watch(maxItemsPerPageProvider);
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Demo'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'App Configuration',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Provider is perfect for global, immutable values that never change during the app lifecycle.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // API Configuration Card
            _buildConfigCard(
              title: 'API Configuration',
              icon: Icons.api,
              color: Colors.blue,
              items: [
                _ConfigItem('Base URL', apiConfig.baseUrl),
                _ConfigItem('Timeout', '${apiConfig.timeout.inSeconds}s'),
                _ConfigItem('API Key', apiConfig.apiKey),
              ],
            ),
            const SizedBox(height: 16),

            // App Settings Card
            _buildConfigCard(
              title: 'App Settings',
              icon: Icons.settings,
              color: Colors.green,
              items: [
                _ConfigItem('Max Items Per Page', '$maxItems'),
                _ConfigItem('Theme Mode', themeMode),
              ],
            ),
            const SizedBox(height: 24),

            // Info Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.amber),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Use Provider for constants and configuration. For mutable state, use NotifierProvider instead.',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<_ConfigItem> items,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 140,
                      child: Text(
                        item.label,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item.value,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfigItem {
  final String label;
  final String value;

  _ConfigItem(this.label, this.value);
}
