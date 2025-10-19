import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedCityNotifier extends Notifier<String> {
  @override
  String build() => 'Doha';

  void setCity(String city) => state = city;
}

final selectedCityProvider = NotifierProvider<SelectedCityNotifier, String>(
  () => SelectedCityNotifier(),
);

/// City coordinates map for API requests.
/// Using records (lat, lon) for cleaner syntax than separate classes.
const cityCoordinates = {
  'Doha': (25.2854, 51.5310),
  'Dubai': (25.2048, 55.2708),
  'London': (51.5074, -0.1278),
  'New York': (40.7128, -74.0060),
  'Tokyo': (35.6762, 139.6503),
};
