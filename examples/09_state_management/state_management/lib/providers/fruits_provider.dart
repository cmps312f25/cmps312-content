import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management/models/fruit.dart';
import 'package:state_management/repositories/fruit_repository.dart';

// FutureProvider for async fruit data loading
final fruitsProvider = FutureProvider<List<Fruit>>(
  (ref) => FruitRepository.getFruits(),
);
