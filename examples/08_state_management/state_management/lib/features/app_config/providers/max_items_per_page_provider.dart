import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Simple constant provider for app configuration.
final maxItemsPerPageProvider = Provider<int>((ref) => 20);
