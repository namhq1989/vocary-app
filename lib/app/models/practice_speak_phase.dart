class PracticeSpeakPhase {
  final String exerciseId;
  final String sentence;
  final List<PracticeSpeakingPart> parts;

  PracticeSpeakPhase({
    required this.exerciseId,
    required this.sentence,
    required this.parts,
  });

  int get totalPoints => parts.fold(0, (sum, part) => sum + part.pointsEarned);

  PracticeSpeakPhase evaluatePartConfidence(int partIndex, double confidence) {
    if (partIndex < 0 || partIndex >= parts.length) return copyWith();

    PracticeSpeakingPart part = parts[partIndex];
    if (part.isCorrect) return copyWith();

    parts[partIndex] = part.evaluateSpeech(confidence);
    return copyWith(parts: parts);
  }

  PracticeSpeakPhase copyWith({
    String? exerciseId,
    String? sentence,
    List<PracticeSpeakingPart>? parts,
  }) {
    return PracticeSpeakPhase(
      exerciseId: exerciseId ?? this.exerciseId,
      sentence: sentence ?? this.sentence,
      parts: parts ?? this.parts,
    );
  }
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

  int get correctPoints => 10;
  final double _confidenceThreshold = 0.8;

  PracticeSpeakingPart evaluateSpeech(double confidence) {
    if (isCorrect) return copyWith();

    isSubmitted = true;
    attempts++;

    // if the actual confidence is below the threshold, consider it incorrect
    isCorrect = confidence >= _confidenceThreshold;
    if (isCorrect) {
      pointsEarned = correctPoints;
    }

    return copyWith(
      isSubmitted: true,
      isCorrect: isCorrect,
      attempts: attempts,
      pointsEarned: pointsEarned,
    );
  }

  PracticeSpeakingPart copyWith({
    String? content,
    bool? isSubmitted,
    bool? isCorrect,
    int? attempts,
    int? pointsEarned,
  }) {
    return PracticeSpeakingPart(
      content: content ?? this.content,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      isCorrect: isCorrect ?? this.isCorrect,
      attempts: attempts ?? this.attempts,
      pointsEarned: pointsEarned ?? this.pointsEarned,
    );
  }
}
