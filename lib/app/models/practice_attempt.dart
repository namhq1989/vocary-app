enum AttemptType { fill, speak }

class PracticeAttempt {
  final String exerciseId;
  final AttemptType type;
  final String answer;
  final bool isCorrect;
  final DateTime timestamp;
  final int partIndex; // Only relevant for speak phase attempts

  PracticeAttempt({
    required this.exerciseId,
    required this.type,
    required this.answer,
    required this.isCorrect,
    this.partIndex = -1,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory PracticeAttempt.forFillPhase({
    required String exerciseId,
    required String answer,
    required bool isCorrect,
  }) {
    return PracticeAttempt(
      exerciseId: exerciseId,
      type: AttemptType.fill,
      answer: answer,
      isCorrect: isCorrect,
    );
  }

  factory PracticeAttempt.forSpeakPhase({
    required String exerciseId,
    required int partIndex,
    required String answer,
    required bool isCorrect,
  }) {
    return PracticeAttempt(
      exerciseId: exerciseId,
      type: AttemptType.speak,
      answer: answer,
      isCorrect: isCorrect,
      partIndex: partIndex,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exerciseId': exerciseId,
      'type': type.toString(),
      'answer': answer,
      'isCorrect': isCorrect,
      'timestamp': timestamp.toIso8601String(),
      'partIndex': partIndex,
    };
  }

  factory PracticeAttempt.fromJson(Map<String, dynamic> json) {
    return PracticeAttempt(
      exerciseId: json['exerciseId'],
      type:
          json['type'] == 'AttemptType.fill'
              ? AttemptType.fill
              : AttemptType.speak,
      answer: json['answer'],
      isCorrect: json['isCorrect'],
      partIndex: json['partIndex'] ?? -1,
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class PracticeAttemptHistory {
  final List<PracticeAttempt> attempts;

  PracticeAttemptHistory({List<PracticeAttempt>? attempts})
    : attempts = attempts ?? [];

  void addAttempt(PracticeAttempt attempt) {
    attempts.add(attempt);
  }

  List<PracticeAttempt> getAttemptsForExercise(String exerciseId) {
    return attempts
        .where((attempt) => attempt.exerciseId == exerciseId)
        .toList();
  }

  List<PracticeAttempt> getFillPhaseAttempts(String exerciseId) {
    return attempts
        .where(
          (attempt) =>
              attempt.exerciseId == exerciseId &&
              attempt.type == AttemptType.fill,
        )
        .toList();
  }

  List<PracticeAttempt> getSpeakPhaseAttempts(String exerciseId) {
    return attempts
        .where(
          (attempt) =>
              attempt.exerciseId == exerciseId &&
              attempt.type == AttemptType.speak,
        )
        .toList();
  }

  List<PracticeAttempt> getSpeakPhaseAttemptsForPart(
    String exerciseId,
    int partIndex,
  ) {
    return attempts
        .where(
          (attempt) =>
              attempt.exerciseId == exerciseId &&
              attempt.type == AttemptType.speak &&
              attempt.partIndex == partIndex,
        )
        .toList();
  }

  /// Returns the accuracy percentage as a rounded integer (0-100)
  int get accuracyPercent {
    if (attempts.isEmpty) return 0;

    final correctAttempts =
        attempts.where((attempt) => attempt.isCorrect).length;
    final percentage = (correctAttempts / attempts.length) * 100;

    return percentage.round();
  }

  /// Returns the accuracy percentage for a specific exercise as a rounded integer (0-100)
  int getExerciseAccuracyPercent(String exerciseId) {
    final exerciseAttempts = getAttemptsForExercise(exerciseId);
    if (exerciseAttempts.isEmpty) return 0;

    final correctAttempts =
        exerciseAttempts.where((attempt) => attempt.isCorrect).length;
    final percentage = (correctAttempts / exerciseAttempts.length) * 100;

    return percentage.round();
  }

  /// Returns the fill phase accuracy percentage as a rounded integer (0-100)
  int getFillPhaseAccuracyPercent() {
    final fillAttempts =
        attempts.where((attempt) => attempt.type == AttemptType.fill).toList();
    if (fillAttempts.isEmpty) return 0;

    final correctAttempts =
        fillAttempts.where((attempt) => attempt.isCorrect).length;
    final percentage = (correctAttempts / fillAttempts.length) * 100;

    return percentage.round();
  }

  /// Returns the speak phase accuracy percentage as a rounded integer (0-100)
  int getSpeakPhaseAccuracyPercent() {
    final speakAttempts =
        attempts.where((attempt) => attempt.type == AttemptType.speak).toList();
    if (speakAttempts.isEmpty) return 0;

    final correctAttempts =
        speakAttempts.where((attempt) => attempt.isCorrect).length;
    final percentage = (correctAttempts / speakAttempts.length) * 100;

    return percentage.round();
  }

  Map<String, dynamic> toJson() {
    return {'attempts': attempts.map((attempt) => attempt.toJson()).toList()};
  }

  factory PracticeAttemptHistory.fromJson(Map<String, dynamic> json) {
    final attemptsList =
        (json['attempts'] as List)
            .map((attemptJson) => PracticeAttempt.fromJson(attemptJson))
            .toList();

    return PracticeAttemptHistory(attempts: attemptsList);
  }
}
