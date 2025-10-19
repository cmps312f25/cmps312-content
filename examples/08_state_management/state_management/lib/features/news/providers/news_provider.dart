import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:state_management/features/news/models/news_model.dart';

/// StreamProvider for continuous data updates.
/// async* creates a generator function (stream)
/// .autoDispose() cleans up when widget unmounts
final newsProvider = StreamProvider.autoDispose<List<NewsArticle>>((
  ref,
) async* {
  const apiKey = 'demo';

  while (true) {
    // Infinite loop for periodic updates
    try {
      final url = Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=us&pageSize=3&apiKey=$apiKey',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final articles = (data['articles'] as List)
            .take(3)
            .map((article) => NewsArticle.fromJson(article))
            .toList();
        yield articles; // Emit data to stream
      } else {
        yield _getSampleNews();
      }
    } catch (e) {
      yield _getSampleNews(); // Fallback on error
    }

    await Future.delayed(const Duration(seconds: 20)); // Wait before next fetch
  }
});

/// Fallback sample data when API is unavailable.
List<NewsArticle> _getSampleNews() {
  final now = DateTime.now();
  return [
    NewsArticle(
      title: 'Breaking: Technology Advances Continue to Shape Future',
      description:
          'Latest developments in artificial intelligence and machine learning are transforming industries worldwide.',
      source: 'Tech News',
      publishedAt: now.subtract(const Duration(hours: 2)).toIso8601String(),
    ),
    NewsArticle(
      title: 'Global Markets Show Positive Growth Trends',
      description:
          'Stock markets around the world demonstrate resilience amid economic challenges.',
      source: 'Financial Times',
      publishedAt: now.subtract(const Duration(hours: 5)).toIso8601String(),
    ),
    NewsArticle(
      title: 'Climate Action Takes Center Stage at Summit',
      description:
          'World leaders gather to discuss sustainable solutions and environmental policies.',
      source: 'World News',
      publishedAt: now.subtract(const Duration(hours: 8)).toIso8601String(),
    ),
  ];
}
