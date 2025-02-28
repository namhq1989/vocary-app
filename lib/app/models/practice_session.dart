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

  double get completionPercentage =>
      exercises.isEmpty
          ? 0
          : (completedExercisesCount / exercises.length) * 100;

  int get totalPoints =>
      exercises.fold(0, (sum, exercise) => sum + exercise.totalPoints);

  Duration get totalTimeSpent => exercises.fold(
    const Duration(),
    (sum, exercise) => sum + exercise.timeSpent,
  );

  bool get hasNextExercise => currentExerciseIndex < exercises.length - 1;

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
