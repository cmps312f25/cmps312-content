import 'package:flutter/material.dart';
import 'package:hikayati/core/entities/category.dart';

const categoryIcons = {
  'explore': Icons.explore,
  'auto_awesome': Icons.auto_awesome,
  'science': Icons.science,
  'favorite': Icons.favorite,
  'pets': Icons.pets,
  'search': Icons.search,
  'history_edu': Icons.history_edu_rounded,
  'park': Icons.park,
  'default': Icons.category,
};

extension CategoryExtension on Category {
  IconData get iconData => categoryIcons[icon] ?? categoryIcons['default']!;
}

