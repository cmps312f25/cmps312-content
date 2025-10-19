import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:state_management/features/weather/models/weather_model.dart';
import 'package:state_management/features/weather/providers/selected_city_provider.dart';

/// FutureProvider for async data fetching.
/// .autoDispose() cleans up when widget unmounts (prevents memory leaks).
/// Automatically re-fetches when selectedCityProvider changes.
final weatherProvider = FutureProvider.autoDispose<Weather>((ref) async {
  final city = ref.watch(selectedCityProvider);
  final coordinates = cityCoordinates[city] ?? cityCoordinates['Doha']!;

  // records.$1 and $2 access first and second elements
  final url = Uri.parse(
    'https://api.open-meteo.com/v1/forecast?'
    'latitude=${coordinates.$1}&'
    'longitude=${coordinates.$2}&'
    'current=temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m&'
    'temperature_unit=celsius&'
    'wind_speed_unit=kmh',
  );

  final response = await http.get(url);
  if (response.statusCode != 200) {
    throw Exception('Failed to load weather data');
  }

  return Weather.fromJson(json.decode(response.body), city);
});
