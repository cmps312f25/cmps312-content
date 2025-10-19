import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Basic Provider for immutable, global values.
/// Use when data never changes during app lifecycle.
/// For mutable state, use NotifierProvider instead.
final apiConfigProvider = Provider<ApiConfig>((ref) {
  return ApiConfig(
    baseUrl: 'https://newsapi.org/v2',
    timeout: const Duration(seconds: 30),
    apiKey: 'demo',
  );
});

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
