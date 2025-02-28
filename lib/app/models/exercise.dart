import 'package:vocary/app/models/practice_fill_phase.dart';
import 'package:vocary/app/models/practice_speak_phase.dart';
import 'package:vocary/app/models/word.dart';

enum ExercisePhase { fill, speak }

class Exercise {
  final String id;
  final Word word;
  final String audioUrl;
  final String sentence;
  final String blankWord;
  final List<String> options;
  final List<String> parts;

  ExercisePhase currentPhase;
  PracticeFillPhase? fillPhase;
  PracticeSpeakPhase? speakPhase;
  bool isCompleted;
  DateTime? startedAt;
  DateTime? completedAt;
  Duration timeSpent;

  Exercise({
    required this.id,
    required this.word,
    required this.blankWord,
    required this.sentence,
    required this.audioUrl,
    required this.options,
    required this.parts,
    this.currentPhase = ExercisePhase.fill,
    this.fillPhase,
    this.speakPhase,
    this.isCompleted = false,
    this.startedAt,
    this.completedAt,
    this.timeSpent = const Duration(),
  });

  int get totalPoints {
    if (fillPhase == null || speakPhase == null) return 0;

    return fillPhase!.pointsEarned + speakPhase!.totalPoints;
  }

  void start() {
    startedAt = DateTime.now();
    currentPhase = ExercisePhase.fill;
  }

  void toSpeakPhase() {
    currentPhase = ExercisePhase.speak;
  }

  void complete() {
    isCompleted = true;
    completedAt = DateTime.now();
    timeSpent = completedAt!.difference(startedAt!);
  }

  factory Exercise.fromJson(Map<String, dynamic> json) {
    final e = Exercise(
      id: json['id'],
      word: Word.fromJson(json['word']),
      audioUrl: json['audioUrl'],
      sentence: json['sentence'],
      blankWord: json['blankWord'],
      options: List<String>.from(json['options']),
      parts: List<String>.from(json['parts']),
    );

    e.fillPhase = PracticeFillPhase(
      exerciseId: e.id,
      sentence: e.sentence,
      blankWord: e.blankWord,
      options: e.options,
    );

    final List<PracticeSpeakingPart> speakingParts = [];
    for (var p in e.parts) {
      speakingParts.add(PracticeSpeakingPart(content: p));
    }
    e.speakPhase = PracticeSpeakPhase(
      exerciseId: e.id,
      sentence: e.sentence,
      parts: speakingParts,
    );

    return e;
  }
}
