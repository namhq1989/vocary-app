import 'dart:math';

import 'package:signals/signals_core.dart';
import 'package:vocary/app/models/exercise.dart';
import 'package:vocary/app/models/practice_config.dart';
import 'package:vocary/app/models/practice_session.dart';
import 'package:vocary/app/models/word.dart';

String randomId() => DateTime.now().millisecondsSinceEpoch.toString();

List<Exercise> _generateRandomExercises(int count) {
  List<Exercise> exercises = [];

  for (int i = 0; i < count; i++) {
    Word randomWord = _generateRandomWord(i);
    String sentence = "This is an example sentence with ${randomWord.word}.";
    String blankWord = randomWord.word;
    List<String> options = _generateOptions(blankWord);

    exercises.add(
      Exercise(
        id: randomId(),
        word: randomWord,
        sentence: sentence,
        blankWord: blankWord,
        audioUrl: "",
        options: options,
        parts: ["Fill in", "the blank", "with the correct word"],
      ),
    );
  }

  return exercises;
}

/// Generates a random word
Word _generateRandomWord(int index) {
  return Word(
    id: "word_$index",
    word: "Word$index",
    definitions: ["Definition for Word$index"],
    pos: ["noun"],
    ipa: "/word$index/",
    audioUrl: "",
    level: "Intermediate",
    synonyms: ["Synonym$index"],
    antonyms: ["Antonym$index"],
    examples: [],
    isFavorite: false,
    isMastered: false,
    currentStreak: Random().nextInt(5),
    masteryThreshold: 5,
  );
}

/// Generates random multiple-choice options
List<String> _generateOptions(String correctAnswer) {
  List<String> options = ["Option1", "Option2", "Option3", correctAnswer];
  options.shuffle();
  return options;
}

class PracticeController {
  final isFetchingExercises = signal<bool>(false);
  final isSubmittingExercise = signal<bool>(false);
  final error = signal<Error?>(null);

  final session = signal<PracticeSession?>(null);

  Future<void> initSession({required PracticeConfig config}) async {
    isFetchingExercises.value = true;

    // Simulated API delay
    await Future.delayed(Duration(seconds: 2));

    List<Exercise> generatedExercises = _generateRandomExercises(
      config.wordCount,
    );

    session.value = PracticeSession.init(generatedExercises);
    isFetchingExercises.value = false;
  }

  Future<void> submitExercise(Exercise exercise) async {}
}
