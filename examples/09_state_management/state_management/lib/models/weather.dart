class Weather {
  final String location;
  final double temperature;
  final double windSpeed;
  final int weatherCode;
  final String weatherDescription;
  final int humidity;

  Weather({
    required this.location,
    required this.temperature,
    required this.windSpeed,
    required this.weatherCode,
    required this.weatherDescription,
    required this.humidity,
  });

  factory Weather.fromJson(Map<String, dynamic> json, String location) {
    final current = json['current'];

    return Weather(
      location: location,
      temperature: current['temperature_2m'].toDouble(),
      windSpeed: current['wind_speed_10m'].toDouble(),
      weatherCode: current['weather_code'],
      weatherDescription: _getWeatherDescription(current['weather_code']),
      humidity: current['relative_humidity_2m'],
    );
  }

  static String _getWeatherDescription(int code) {
    // WMO Weather interpretation codes
    if (code == 0) return 'Clear sky';
    if (code <= 3) return 'Partly cloudy';
    if (code <= 48) return 'Foggy';
    if (code <= 67) return 'Rainy';
    if (code <= 77) return 'Snowy';
    if (code <= 82) return 'Rain showers';
    if (code <= 86) return 'Snow showers';
    if (code <= 99) return 'Thunderstorm';
    return 'Unknown';
  }

  String get weatherEmoji {
    if (weatherCode == 0) return '☀️';
    if (weatherCode <= 3) return '⛅';
    if (weatherCode <= 48) return '🌫️';
    if (weatherCode <= 67) return '🌧️';
    if (weatherCode <= 77) return '🌨️';
    if (weatherCode <= 82) return '🌦️';
    if (weatherCode <= 86) return '❄️';
    if (weatherCode <= 99) return '⛈️';
    return '🌡️';
  }
}
