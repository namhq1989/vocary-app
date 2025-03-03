import 'package:vocary/app/models/practice_fill_phase.dart';
import 'package:vocary/app/models/practice_speak_phase.dart';
import 'package:vocary/app/models/practice_attempt.dart';
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
  PracticeAttemptHistory attemptHistory;

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
    PracticeAttemptHistory? attemptHistory,
  }) : attemptHistory = attemptHistory ?? PracticeAttemptHistory();

  int get totalPoints {
    int total = 0;

    // Fill Phase points
    if (fillPhase != null && fillPhase!.isSubmitted) {
      total += fillPhase!.pointsEarned;
    }

    // Speak Phase points
    if (speakPhase != null && isSpeakPhase) {
      for (var part in speakPhase!.parts) {
        if (part.isSubmitted && part.isCorrect) {
          total += 10;
        }
      }
    }

    return total;
  }

  bool get isSpeakPhase => currentPhase == ExercisePhase.speak;

  Exercise start() {
    return copyWith(
      startedAt: DateTime.now(),
      currentPhase: ExercisePhase.fill,
    );
  }

  Exercise toSpeakPhase() {
    return copyWith(currentPhase: ExercisePhase.speak);
  }

  Exercise complete() {
    completedAt = DateTime.now();
    timeSpent = completedAt!.difference(startedAt!);

    return copyWith(
      isCompleted: true,
      completedAt: completedAt,
      timeSpent: timeSpent,
    );
  }

  Exercise evaluateFillPhaseAnswer(String answer) {
    if (fillPhase == null) return copyWith();

    // Evaluate the answer
    fillPhase = fillPhase?.evaluateResult(answer);

    // Create and save the attempt history
    final attempt = PracticeAttempt.forFillPhase(
      exerciseId: id,
      answer: answer,
      isCorrect: fillPhase?.isCorrect ?? false,
    );
    attemptHistory.addAttempt(attempt);

    return copyWith(fillPhase: fillPhase, attemptHistory: attemptHistory);
  }

  Exercise evaluateSpeakPhasePart(int partIndex, double confidence) {
    if (speakPhase == null) return copyWith();

    // Evaluate the part confidence
    speakPhase = speakPhase?.evaluatePartConfidence(partIndex, confidence);

    // Get the part that was evaluated
    final part = speakPhase?.parts[partIndex];
    if (part != null) {
      // Create and save the attempt history
      final attempt = PracticeAttempt.forSpeakPhase(
        exerciseId: id,
        partIndex: partIndex,
        answer: confidence.toString(), // Store confidence as the answer
        isCorrect: part.isCorrect,
      );
      attemptHistory.addAttempt(attempt);
    }

    return copyWith(speakPhase: speakPhase, attemptHistory: attemptHistory);
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
      attemptHistory:
          json['attemptHistory'] != null
              ? PracticeAttemptHistory.fromJson(json['attemptHistory'])
              : PracticeAttemptHistory(),
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

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "word": word.toJson(),
      "audioUrl": audioUrl,
      "sentence": sentence,
      "blankWord": blankWord,
      "options": options,
      "parts": parts,
      "currentPhase": currentPhase,
      "isCompleted": isCompleted,
      "startedAt": startedAt?.toIso8601String(),
      "completedAt": completedAt?.toIso8601String(),
      "timeSpent": timeSpent.toString(),
      "attemptHistory": attemptHistory.toJson(),
    };
  }

  Exercise copyWith({
    String? id,
    Word? word,
    String? audioUrl,
    String? sentence,
    String? blankWord,
    List<String>? options,
    List<String>? parts,
    bool? isCompleted,
    ExercisePhase? currentPhase,
    PracticeFillPhase? fillPhase,
    PracticeSpeakPhase? speakPhase,
    DateTime? startedAt,
    DateTime? completedAt,
    Duration? timeSpent,
    PracticeAttemptHistory? attemptHistory,
  }) {
    return Exercise(
      id: id ?? this.id,
      word: word ?? this.word,
      audioUrl: audioUrl ?? this.audioUrl,
      sentence: sentence ?? this.sentence,
      blankWord: blankWord ?? this.blankWord,
      options: options ?? this.options,
      parts: parts ?? this.parts,
      isCompleted: isCompleted ?? this.isCompleted,
      currentPhase: currentPhase ?? this.currentPhase,
      fillPhase: fillPhase ?? this.fillPhase,
      speakPhase: speakPhase ?? this.speakPhase,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      timeSpent: timeSpent ?? this.timeSpent,
      attemptHistory: attemptHistory ?? this.attemptHistory,
    );
  }
}
