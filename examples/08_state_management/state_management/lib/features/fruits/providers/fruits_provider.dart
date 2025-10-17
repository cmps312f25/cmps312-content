import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management/features/fruits/models/fruit_model.dart';
import 'package:state_management/features/fruits/repositories/fruit_repository.dart';

// FutureProvider for async fruit data loading
final fruitsProvider = FutureProvider<List<Fruit>>(
  (ref) => FruitRepository.getFruits(),
);
