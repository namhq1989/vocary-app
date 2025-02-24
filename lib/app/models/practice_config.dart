class PracticeConfig {
  final int wordCount;
  final AnswerMethod answerMethod;

  PracticeConfig({required this.wordCount, required this.answerMethod});

  @override
  String toString() {
    return 'PracticeConfig(wordCount: $wordCount, answerMethod: $answerMethod)';
  }
}

enum AnswerMethod { multipleChoice, textInput }
