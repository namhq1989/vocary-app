class PracticeFillPhase {
  final String exerciseId;
  final String sentence;
  final String blankWord;
  final List<String> options;

  String userAnswer;
  bool isSubmitted;
  bool isCorrect;
  int attempts;
  int pointsEarned;

  PracticeFillPhase({
    required this.exerciseId,
    required this.sentence,
    required this.blankWord,
    required this.options,

    this.userAnswer = '',
    this.isCorrect = false,
    this.attempts = 0,
    this.isSubmitted = false,
    this.pointsEarned = 0,
  });

  final int _correctPoints = 10;

  PracticeFillPhase evaluateResult(String answer) {
    if (isCorrect == true) return copyWith();

    isSubmitted = true;
    attempts++;
    userAnswer = answer;

    isCorrect = answer.trim().toLowerCase() == blankWord.trim().toLowerCase();

    if (isCorrect) {
      pointsEarned = _correctPoints;
    }

    return copyWith(
      isSubmitted: isSubmitted,
      attempts: attempts,
      userAnswer: userAnswer,
      isCorrect: isCorrect,
      pointsEarned: pointsEarned,
    );
  }

  PracticeFillPhase copyWith({
    String? exerciseId,
    String? sentence,
    String? blankWord,
    List<String>? options,
    String? userAnswer,
    bool? isSubmitted,
    bool? isCorrect,
    int? attempts,
    int? pointsEarned,
  }) => PracticeFillPhase(
    exerciseId: exerciseId ?? this.exerciseId,
    sentence: sentence ?? this.sentence,
    blankWord: blankWord ?? this.blankWord,
    options: options ?? this.options,
    userAnswer: userAnswer ?? this.userAnswer,
    isSubmitted: isSubmitted ?? this.isSubmitted,
    isCorrect: isCorrect ?? this.isCorrect,
    attempts: attempts ?? this.attempts,
    pointsEarned: pointsEarned ?? this.pointsEarned,
  );
}
