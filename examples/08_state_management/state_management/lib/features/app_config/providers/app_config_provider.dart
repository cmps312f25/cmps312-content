import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for app configuration (immutable, global constants)
// Perfect use case for Provider - values that never change during app lifecycle
final apiConfigProvider = Provider<ApiConfig>((ref) {
  return ApiConfig(
    baseUrl: 'https://newsapi.org/v2',
    timeout: const Duration(seconds: 30),
    apiKey: 'demo',
  );
});

// Provider for max items per page (business logic constant)
final maxItemsPerPageProvider = Provider<int>((ref) => 20);

// Provider for app theme mode preference (could be computed from settings)
final themeModeProvider = Provider<String>((ref) => 'light');

// Configuration model
class ApiConfig {
  final String baseUrl;
  final Duration timeout;
  final String apiKey;

  const ApiConfig({
    required this.baseUrl,
    required this.timeout,
    required this.apiKey,
  });
}
