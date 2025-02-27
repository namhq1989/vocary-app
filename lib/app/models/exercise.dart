import 'package:vocary/app/models/word.dart';

class Exercise {
  final String id;
  final String audioUrl;
  final Word word;
  final String content;
  final List<String> options;
  final String correctAnswer;
  final bool isFavorite;
  final DateTime nextReviewAt;

  const Exercise({
    required this.id,
    required this.audioUrl,
    required this.word,
    required this.content,
    required this.options,
    required this.correctAnswer,
    required this.isFavorite,
    required this.nextReviewAt,
  });
}
