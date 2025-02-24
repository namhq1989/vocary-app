import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:vocary/app/models/practice_config.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
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
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return GestureDetector(
      onVerticalDragDown: (_) {},
      child: DraggableScrollableSheet(
        initialChildSize: 1,
        minChildSize: 1,
        maxChildSize: 1,
        builder: (context, scrollController) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: showExitConfirmation,
                    ),
                  ),
                  Text(
                    sentence,
                    style: theme.textTheme.h3,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  if (config.answerMethod == AnswerMethod.multipleChoice)
                    Column(
                      children:
                          options.map((option) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
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
                      ),
                    ),
                ],
              ),
            ),
            bottomNavigationBar: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ShadButton(
                  onPressed: submitted ? null : checkAnswer,
                  child: const Text("Submit"),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
