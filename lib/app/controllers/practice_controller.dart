import 'dart:math';

import 'package:signals/signals_core.dart';
import 'package:vocary/app/models/exercise.dart';
import 'package:vocary/app/models/practice_config.dart';
import 'package:vocary/app/models/practice_fill_phase.dart';
import 'package:vocary/app/models/practice_session.dart';
import 'package:vocary/app/models/practice_speak_phase.dart';
import 'package:vocary/app/models/word.dart';

String randomId() => DateTime.now().millisecondsSinceEpoch.toString();

List<Exercise> _generateRandomExercises(int count) {
  List<Exercise> exercises = [];

  for (int i = 0; i < count; i++) {
    Word randomWord = _generateRandomWord(i);
    String sentence = "This is an example sentence with ${randomWord.word}.";
    String blankWord = randomWord.word;
    List<String> options = _generateOptions(blankWord);
    List<String> parts = ["Fill in", "the blank", "with the correct word"];

    List<PracticeSpeakingPart> speakingParts = [];
    for (var p in parts) {
      speakingParts.add(PracticeSpeakingPart(content: p));
    }

    final exerciseId = "ex_${i}_${randomId()}";
    exercises.add(
      Exercise(
        id: exerciseId,
        word: randomWord,
        sentence: sentence,
        blankWord: blankWord,
        audioUrl: "",
        options: options,
        parts: parts,
        fillPhase: PracticeFillPhase(
          exerciseId: exerciseId,
          sentence: sentence,
          blankWord: blankWord,
          options: options,
        ),
        speakPhase: PracticeSpeakPhase(
          exerciseId: exerciseId,
          sentence: sentence,
          parts: speakingParts,
        ),
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

  bool get isOnFinalExercise {
    final session = this.session.value;
    if (session == null) return false;

    return !session.hasNextExercise;
  }

  Future<void> initSession({required PracticeConfig config}) async {
    isFetchingExercises.value = true;

    // Simulated API delay
    await Future.delayed(Duration(seconds: 1));

    List<Exercise> generatedExercises = _generateRandomExercises(
      config.wordCount,
    );

    session.value = PracticeSession.init(generatedExercises);
    isFetchingExercises.value = false;

    startExercise();
  }

  void updateCurrentExercise(Exercise exercise) {
    final updatedExercises =
        session.value!.exercises
            .map((e) => e.id == exercise.id ? exercise : e)
            .toList();
    session.value?.updateExercises(updatedExercises);

    session.set(session.value, force: true);
  }

  void startExercise() {
    final exercise = session.value!.currentExercise;
    if (exercise == null) return;

    final updatedExercise = exercise.start();
    updateCurrentExercise(updatedExercise);
  }

  void submitFillPhaseAnswer(String answer) {
    final exercise = session.value!.currentExercise;
    if (exercise == null) return;

    final updatedExercise = exercise.evaluateFillPhaseAnswer(answer);
    updateCurrentExercise(updatedExercise);
  }

  void submitSpeakPhasePart(int partIndex, double confidence) {
    final exercise = session.value!.currentExercise;
    if (exercise == null) return;

    final updatedExercise = exercise.evaluateSpeakPhasePart(
      partIndex,
      confidence,
    );
    updateCurrentExercise(updatedExercise);
  }

  void toSpeakPhase() {
    final exercise = session.value!.currentExercise;
    if (exercise == null) return;

    final updatedExercise = exercise.toSpeakPhase();
    updateCurrentExercise(updatedExercise);
  }

  void toNextExercise() {
    final hasNextExercise = session.value!.hasNextExercise;
    if (!hasNextExercise) {
      return;
    }

    final exercise = session.value!.currentExercise;
    if (exercise == null) {
      return;
    }

    // Mark the current exercise as completed
    final updatedExercise = exercise.complete();
    updateCurrentExercise(updatedExercise);

    if (isOnFinalExercise) {
      session.value!.complete();
      print("Final exercise completed, practice session complete!");
    } else {
      session.value!.toNextExercise();
    }
  }
}
