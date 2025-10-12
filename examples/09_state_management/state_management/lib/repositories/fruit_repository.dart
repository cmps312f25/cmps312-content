import 'package:state_management/models/fruit.dart';

class FruitRepository {
  // Simulates async API call to fetch fruits
  static Future<List<Fruit>> getFruits() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    return [
      Fruit(
        name: 'Apple',
        imageUrl: 'assets/images/apple.jpg',
        title: 'High in fiber and antioxidants.',
        description:
            'Apples are highly nutritious fruits rich in fiber and vitamin C. '
            'Regular consumption can improve heart health, reduce diabetes risk, '
            'and aid in weight loss.',
      ),
      Fruit(
        name: 'Banana',
        imageUrl: 'assets/images/banana.jpg',
        title: 'Rich in potassium and energy.',
        description:
            'Bananas are known for their high potassium content, essential for '
            'healthy blood pressure and heart function. They provide energy and '
            'aid digestion.',
      ),
      Fruit(
        name: 'Orange',
        imageUrl: 'assets/images/orange.jpg',
        title: 'Loaded with vitamin C.',
        description:
            'Oranges are citrus fruits loaded with vitamin C, vital for immune '
            'function. They help reduce chronic disease risk and support healthy skin.',
      ),
      Fruit(
        name: 'Strawberry',
        imageUrl: 'assets/images/strawberry.jpg',
        title: 'Full of vitamins and antioxidants.',
        description:
            'Strawberries are rich in vitamin C, manganese, and antioxidants. '
            'They help combat oxidative stress and support heart health.',
      ),
      Fruit(
        name: 'Watermelon',
        imageUrl: 'assets/images/watermelon.jpg',
        title: 'Hydrating and refreshing.',
        description:
            'Watermelons are exceptionally hydrating, mostly comprised of water. '
            'They improve heart health, lower inflammation, and relieve muscle soreness.',
      ),
      Fruit(
        name: 'Grape',
        imageUrl: 'assets/images/grape.jpg',
        title: 'Good source of vitamins and minerals.',
        description:
            'Grapes contain vitamins C and K, and antioxidants called polyphenols. '
            'They are beneficial for heart health and may improve blood sugar balance.',
      ),
    ];
  }
}
