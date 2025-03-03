class PracticeConfig {
  final String collectionId;
  final int wordCount;
  final AnswerMethod answerMethod;

  PracticeConfig({
    required this.collectionId,
    required this.wordCount,
    required this.answerMethod,
  });

  @override
  String toString() {
    return 'PracticeConfig(collectionId: $collectionId, wordCount: $wordCount, answerMethod: $answerMethod)';
  }

  static PracticeConfig defaultConfig() {
    return PracticeConfig(
      collectionId: '',
      wordCount: 2,
      answerMethod: AnswerMethod.multipleChoice,
    );
  }
}

enum AnswerMethod { multipleChoice, textInput }
