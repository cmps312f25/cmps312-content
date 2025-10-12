import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management/features/weather/providers/weather_provider.dart';

class WeatherScreen extends ConsumerWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(weatherProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
        actions: const [_CitySelector()],
      ),
      body: weatherAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => _ErrorState(error: err.toString(), ref: ref),
        data: (weather) => _WeatherContent(weather: weather),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.refresh(weatherProvider),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

// City selector dropdown
class _CitySelector extends ConsumerWidget {
  const _CitySelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCity = ref.watch(selectedCityProvider);

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: DropdownButton<String>(
        value: selectedCity,
        items: cityCoordinates.keys
            .map((city) => DropdownMenuItem(value: city, child: Text(city)))
            .toList(),
        onChanged: (city) {
          if (city != null) {
            ref.read(selectedCityProvider.notifier).setCity(city);
          }
        },
      ),
    );
  }
}

// Error state
class _ErrorState extends StatelessWidget {
  final String error;
  final WidgetRef ref;

  const _ErrorState({required this.error, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text('Error: $error'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => ref.refresh(weatherProvider),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

// Weather content
class _WeatherContent extends StatelessWidget {
  final dynamic weather;

  const _WeatherContent({required this.weather});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              weather.location,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(weather.weatherEmoji, style: const TextStyle(fontSize: 72)),
            const SizedBox(height: 8),
            Text(
              weather.weatherDescription,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            _TemperatureCard(weather: weather),
            const SizedBox(height: 16),
            const Text(
              'Data from Open-Meteo.com',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// Temperature card
class _TemperatureCard extends StatelessWidget {
  final dynamic weather;

  const _TemperatureCard({required this.weather});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  weather.temperature.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 52,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  '°C',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _DetailItem(
                  icon: Icons.water_drop,
                  label: 'Humidity',
                  value: '${weather.humidity}%',
                ),
                _DetailItem(
                  icon: Icons.air,
                  label: 'Wind',
                  value: '${weather.windSpeed.toStringAsFixed(1)} km/h',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Detail item
class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 26, color: Colors.blue),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
