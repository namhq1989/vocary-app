class PracticeSpeakPhase {
  final String exerciseId;
  final String sentence;
  final List<PracticeSpeakingPart> parts;
  int currentPart;

  PracticeSpeakPhase({
    required this.exerciseId,
    required this.sentence,
    required this.parts,
    this.currentPart = 0,
  });

  int get totalPoints => parts.fold(0, (sum, part) => sum + part.pointsEarned);
}

class PracticeSpeakingPart {
  final String content;

  bool isSubmitted;
  bool isCorrect;
  int attempts;
  int pointsEarned;

  PracticeSpeakingPart({
    required this.content,
    this.isSubmitted = false,
    this.isCorrect = false,
    this.attempts = 0,
    this.pointsEarned = 0,
  });

  final int _correctPoints = 10;
  final double _confidenceThreshold = 0.8;

  PracticeSpeakingPart evaluateSpeech(double confidence) {
    if (isCorrect) return copyWith();

    isSubmitted = true;
    attempts++;

    // if the actual confidence is below the threshold, consider it incorrect
    isCorrect = confidence >= _confidenceThreshold;
    if (isCorrect) {
      pointsEarned = _correctPoints;
    }

    return copyWith(
      isSubmitted: isSubmitted,
      attempts: attempts,
      isCorrect: isCorrect,
      pointsEarned: pointsEarned,
    );
  }

  copyWith({
    String? content,
    bool? isSubmitted,
    bool? isCorrect,
    int? attempts,
    int? pointsEarned,
  }) => PracticeSpeakingPart(
    content: content ?? this.content,
    isSubmitted: isSubmitted ?? this.isSubmitted,
    isCorrect: isCorrect ?? this.isCorrect,
    attempts: attempts ?? this.attempts,
    pointsEarned: pointsEarned ?? this.pointsEarned,
  );
}
