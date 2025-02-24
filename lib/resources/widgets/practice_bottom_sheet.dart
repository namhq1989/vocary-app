import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:vocary/app/models/practice_config.dart';

void showPracticeBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    enableDrag: false, // Prevents dragging
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => const _PracticeBottomSheetContent(),
  );
}

class _PracticeBottomSheetContent extends StatefulWidget {
  const _PracticeBottomSheetContent();

  @override
  State<_PracticeBottomSheetContent> createState() =>
      _PracticeBottomSheetContentState();
}

class _PracticeBottomSheetContentState
    extends State<_PracticeBottomSheetContent> {
  final PracticeConfig config = PracticeConfig(
    wordCount: 5,
    answerMethod: AnswerMethod.multipleChoice,
  );

  String selectedAnswer = "";
  final TextEditingController _textController = TextEditingController();

  final String sentence = "She is very ______ after setbacks.";
  final String correctAnswer = "resilient";
  final List<String> options = ["confident", "resilient", "passionate", "weak"];

  bool isCorrect = false;
  bool submitted = false;
  bool isLoading = true;

  // Session Data
  int currentExercise = 1;
  int totalExercises = 5;
  int streak = 4;
  int score = 200;
  Duration remainingTime = const Duration(minutes: 3, seconds: 45);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadExercises();
    _startFakeTimer();
  }

  Future<void> _loadExercises() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate API loading
    setState(() {
      isLoading = false;
    });
  }

  void _startFakeTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime.inSeconds > 0) {
        setState(() {
          remainingTime -= const Duration(seconds: 1);
        });
      } else {
        timer.cancel();
      }
    });
  }

  void checkAnswer() {
    setState(() {
      submitted = true;
      isCorrect =
          config.answerMethod == AnswerMethod.multipleChoice
              ? selectedAnswer == correctAnswer
              : _textController.text.trim().toLowerCase() == correctAnswer;
    });
  }

  void showExitConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Exit Practice?"),
          content: const Text("Are you sure you want to leave the practice?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("Exit", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child:
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header (Fixed 200px height)
                      SizedBox(height: 200, child: _buildSessionHeader(theme)),
                      const SizedBox(height: 24),

                      // Sentence
                      Text(
                        sentence,
                        style: theme.textTheme.h2.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // Answer Section
                      if (config.answerMethod == AnswerMethod.multipleChoice)
                        Column(
                          children:
                              options.map((option) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  child:
                                      selectedAnswer == option
                                          ? ShadButton(
                                            onPressed: () {},
                                            child: Text(option),
                                          )
                                          : ShadButton.outline(
                                            onPressed: () {
                                              if (!submitted) {
                                                setState(
                                                  () => selectedAnswer = option,
                                                );
                                              }
                                            },
                                            child: Text(option),
                                          ),
                                );
                              }).toList(),
                        )
                      else
                        ShadInput(
                          controller: _textController,
                          placeholder: const Text("Type your answer"),
                        ),

                      const SizedBox(height: 24),

                      // Result Feedback
                      if (submitted)
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            isCorrect
                                ? "✅ Correct!"
                                : "❌ Incorrect. The answer is '$correctAnswer'",
                            style: theme.textTheme.large.copyWith(
                              color: isCorrect ? Colors.green : Colors.red,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
        ),

        bottomNavigationBar:
            isLoading
                ? null
                : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ShadButton(
                      onPressed: submitted ? null : checkAnswer,
                      child: const Text("Submit"),
                    ),
                  ),
                ),
      ),
    );
  }

  Widget _buildSessionHeader(ShadThemeData theme) {
    return Column(
      children: [
        // Close Button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(LucideIcons.arrowLeft, size: 24),
              onPressed: showExitConfirmation,
            ),
            Text("Practice Session", style: theme.textTheme.h3),
            const SizedBox(width: 40), // Placeholder to balance layout
          ],
        ),

        const SizedBox(height: 12),

        // Progress, Streak, Timer
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("🔥 Streak: $streak", style: theme.textTheme.large),
            Text(
              "$currentExercise / $totalExercises",
              style: theme.textTheme.large,
            ),
            Text(
              "⏳ ${remainingTime.inMinutes}:${remainingTime.inSeconds % 60}",
              style: theme.textTheme.large,
            ),
          ],
        ),

        // Progress Bar
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: currentExercise / totalExercises,
            backgroundColor: theme.colorScheme.border,
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.primary,
            ),
          ),
        ),

        // Collection Name
        const SizedBox(height: 16),
        Text(
          "📖 Collection: Advanced Vocabulary",
          style: theme.textTheme.muted,
        ),
      ],
    );
  }
}
