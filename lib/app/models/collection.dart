import 'package:flutter/widgets.dart';

class Collection {
  final String name;
  final String description;
  final IconData icon;
  final int totalWords;

  Collection({
    required this.name,
    required this.description,
    required this.icon,
    required this.totalWords,
  });
}
