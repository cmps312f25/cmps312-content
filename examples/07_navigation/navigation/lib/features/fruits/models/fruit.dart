/// Fruit model representing nutritional information and details
/// Immutable data class following best practices
class Fruit {
  final String name;
  final String imageUrl;
  final String title;
  final String description;

  const Fruit({
    required this.name,
    required this.imageUrl,
    required this.title,
    required this.description,
  });
}
