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

    this.userAnswer = "",
    this.isCorrect = false,
    this.attempts = 0,
    this.isSubmitted = false,
    this.pointsEarned = 0,
  });

  final int _correctPoints = 10;

  PracticeFillPhase evaluateResult(String answer) {
    if (isCorrect == true) return this;

    userAnswer = answer;
    isSubmitted = true;
    attempts++;

    isCorrect = answer.trim().toLowerCase() == blankWord.trim().toLowerCase();

    if (isCorrect) {
      pointsEarned = _correctPoints;
    }

    return this;
  }
}
