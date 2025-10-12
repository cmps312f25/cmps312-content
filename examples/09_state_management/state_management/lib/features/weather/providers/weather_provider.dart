import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:state_management/features/weather/models/weather_model.dart';

// Notifier for managing the selected city
class SelectedCityNotifier extends Notifier<String> {
  @override
  String build() => 'Doha'; // Initial value

  void setCity(String city) {
    state = city;
  }
}

// Provider for the selected city
final selectedCityProvider = NotifierProvider<SelectedCityNotifier, String>(
  () => SelectedCityNotifier(),
);

// City coordinates (latitude, longitude)
const cityCoordinates = {
  'Doha': (25.2854, 51.5310),
  'Dubai': (25.2048, 55.2708),
  'London': (51.5074, -0.1278),
  'New York': (40.7128, -74.0060),
  'Tokyo': (35.6762, 139.6503),
};

// .autoDispose() is used to automatically dispose
// the provider when no longer needed
final weatherProvider = FutureProvider.autoDispose<Weather>((ref) async {
  final city = ref.watch(selectedCityProvider);
  final coordinates = cityCoordinates[city] ?? cityCoordinates['Doha']!;

  // Open-Meteo API - Free weather API, no API key required
  final url = Uri.parse(
    'https://api.open-meteo.com/v1/forecast?'
    'latitude=${coordinates.$1}&'
    'longitude=${coordinates.$2}&'
    'current=temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m&'
    'temperature_unit=celsius&'
    'wind_speed_unit=kmh',
  );

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return Weather.fromJson(data, city);
  } else {
    throw Exception('Failed to load weather data');
  }
});
