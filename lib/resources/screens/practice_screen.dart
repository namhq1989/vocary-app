import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:vocary/app/signals/navbar_signal.dart';
import 'package:vocary/core/design.dart';
import 'package:vocary/resources/widgets/sentence_with_blank_widget.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  int totalPoints = 120; // Example points
  int completedExercises = 3; // Example completed exercises
  int totalExercises = 5;

  final String sentence = "She is very resilient after setbacks";
  final String correctAnswer = "resilient";
  final List<String> options = ["confident", "resilient", "passionate", "weak"];

  String? selectedAnswer;
  bool submitted = false;
  bool isCorrect = false;

  @override
  void initState() {
    super.initState();
    NavBarSignals.isVisible.value = false;
  }

  @override
  void dispose() {
    NavBarSignals.isVisible.value = true;
    super.dispose();
  }

  Future<bool> _onBackPressed() async {
    bool? shouldExit = await showShadDialog<bool>(
      context: context,
      builder:
          (context) => ShadDialog.alert(
            title: const Text('Vocary'),
            description: const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text('Are you sure you want to leave this session?'),
            ),
            gap: 20,
            actions: [
              ShadButton.outline(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              const SizedBox(height: 4),
              ShadButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Exit'),
              ),
            ],
          ),
    );

    if (shouldExit == true && mounted) {
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
    }

    return shouldExit ?? false;
  }

  void checkAnswer() {
    setState(() {
      submitted = true;
      isCorrect = selectedAnswer == correctAnswer;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        bool exit = await _onBackPressed();
        if (exit && context.mounted) Navigator.pop(context);
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _buildCustomHeader(context),
                const SizedBox(height: 24),
                _buildHeader(context),
                const SizedBox(height: 24),

                // Scrollable Content (Answers, Feedback, Submit Button)
                Expanded(
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(
                      context,
                    ).copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      physics:
                          const ClampingScrollPhysics(), // Enables scrolling only if needed
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 32,
                        ), // Space for better UX
                        child: _buildPracticeContent(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // New custom header widget
  Widget _buildCustomHeader(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Exercise title on the left
          Text(
            'Intermediate',
            style: theme.textTheme.h4.copyWith(
              color: theme.colorScheme.foreground,
            ),
          ),

          // Close icon on the right
          IconButton(
            icon: Icon(
              LucideIcons.x,
              size: 24,
              color: ShadTheme.of(context).colorScheme.foreground,
            ),
            onPressed: _onBackPressed,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            style: IconButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Points & Progress in the same row (opposite sides)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  LucideIcons.star,
                  color: ShadTheme.of(context).colorScheme.foreground,
                  size: 20,
                ),
                const SizedBox(width: 6),
                Text(
                  "$totalPoints Points",
                  style: theme.textTheme.large.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            Text(
              "Stage: $completedExercises/$totalExercises",
              style: theme.textTheme.large.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Progress Bar
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: completedExercises / totalExercises,
            backgroundColor: theme.colorScheme.border,
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.primary,
            ),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildPracticeContent(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text('Complete the sentence:', style: theme.textTheme.p),
        const SizedBox(height: 32),

        // Sentence with blank
        SentenceWithBlankWidget(
          sentence: sentence,
          wordToBlank: correctAnswer,
          textStyle: TextStyle(fontSize: 22, height: 1.4),
        ),
        const SizedBox(height: 16),

        // Answer Options
        Column(
          children:
              options.map((option) {
                bool isSelected = selectedAnswer == option;
                bool isCorrectOption = submitted && option == correctAnswer;
                bool isIncorrectOption =
                    submitted && isSelected && option != correctAnswer;

                return GestureDetector(
                  onTap: () {
                    if (!submitted) {
                      setState(() => selectedAnswer = option);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: theme.colorScheme.border),
                        borderRadius: BorderRadius.circular(12),
                        color:
                            isCorrectOption
                                ? AppColors.successColor.withAlpha(25)
                                : isSelected
                                ? theme.colorScheme.primary.withAlpha(25)
                                : theme.colorScheme.background,
                      ),
                      child: Text(
                        option,
                        style: theme.textTheme.p.copyWith(
                          color:
                              isCorrectOption
                                  ? AppColors.successColor
                                  : isIncorrectOption
                                  ? AppColors.errorColor
                                  : theme.colorScheme.foreground,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),

        const SizedBox(height: 8),

        // Feedback Message (Only Visible After Submitting)
        if (submitted) _buildFeedbackContainer(context),

        const SizedBox(height: 16),
        ShadButton(
          height: 44,
          onPressed: submitted ? null : checkAnswer,
          child: const Text("Submit"),
        ),
      ],
    );
  }

  Widget _buildFeedbackContainer(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color:
            isCorrect
                ? AppColors.successColor.withAlpha(25)
                : AppColors.errorColor.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            isCorrect ? Icons.check_circle : Icons.error,
            color: isCorrect ? AppColors.successColor : AppColors.errorColor,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              isCorrect
                  ? "Great job! You've selected the correct answer."
                  : "Not quite right. The correct answer is '$correctAnswer'. Let's keep practicing!",
              style: theme.textTheme.p.copyWith(
                fontWeight: FontWeight.w500,
                color:
                    isCorrect ? AppColors.successColor : AppColors.errorColor,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
