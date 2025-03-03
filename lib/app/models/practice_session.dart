import 'package:vocary/app/models/exercise.dart';

class PracticeSession {
  List<Exercise> exercises;
  int currentExerciseIndex;
  bool isCompleted;

  PracticeSession._({required this.exercises})
    : currentExerciseIndex = 0,
      isCompleted = false;

  factory PracticeSession.init(List<Exercise> exercises) {
    return PracticeSession._(exercises: exercises);
  }

  Exercise? get currentExercise =>
      currentExerciseIndex < exercises.length
          ? exercises[currentExerciseIndex]
          : null;

  int get completedExercisesCount =>
      exercises.where((exercise) => exercise.isCompleted).length;

  double get completionRatio =>
      exercises.isEmpty ? 0 : completedExercisesCount / exercises.length;

  int get totalPoints {
    int total = 0;
    for (int i = 0; i < exercises.length; i++) {
      Exercise exercise = exercises[i];

      if (exercise.isCompleted || i == currentExerciseIndex) {
        total += exercise.totalPoints;
      }
    }

    return total;
  }

  Duration get totalTimeSpent => exercises.fold(
    const Duration(),
    (sum, exercise) => sum + exercise.timeSpent,
  );

  bool get hasNextExercise => currentExerciseIndex < exercises.length - 1;

  int get accuracyPercent {
    if (exercises.isEmpty) return 0;

    int totalAccuracyPercent = 0;
    for (var exercise in exercises) {
      totalAccuracyPercent += exercise.attemptHistory.accuracyPercent;
    }

    var percent = totalAccuracyPercent / (exercises.length * 100) * 100;
    return percent.round();
  }

  void updateExercises(List<Exercise> updatedExercises) =>
      exercises = updatedExercises;

  void toNextExercise() {
    if (!hasNextExercise) {
      complete();
      return;
    }

    currentExerciseIndex++;
  }

  void complete() {
    isCompleted = true;
  }

  Map<String, dynamic> toJson() {
    return {
      "exercises": exercises.map((e) => e.toJson()).toList(),
      "currentExerciseIndex": currentExerciseIndex,
      "isCompleted": isCompleted,
    };
  }
}
