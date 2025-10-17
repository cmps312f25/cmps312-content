class NewsArticle {
  final String title;
  final String description;
  final String source;
  final String publishedAt;

  NewsArticle({
    required this.title,
    required this.description,
    required this.source,
    required this.publishedAt,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? 'No title',
      description: json['description'] ?? 'No description available',
      source: json['source']?['name'] ?? 'Unknown',
      publishedAt: json['publishedAt'] ?? '',
    );
  }
}
