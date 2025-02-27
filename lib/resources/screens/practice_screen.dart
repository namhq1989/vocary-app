import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:vocary/app/signals/navbar_signal.dart';
import 'package:vocary/core/design.dart';
import 'package:vocary/resources/widgets/practice_points_widget.dart';
import 'package:vocary/resources/widgets/sentence_with_blank_widget.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen>
    with SingleTickerProviderStateMixin {
  int completedExercises = 3; // Example completed exercises
  int totalExercises = 5;

  final Points totalPoints = Points(0);
  final String sentence = "She is very resilient after setbacks";
  final String correctAnswer = "resilient";
  final List<String> options = ["confident", "resilient", "passionate", "weak"];

  Map<String, bool?> speakingResults = {};
  String? selectedAnswer;
  bool isSpeakingMode = false;
  bool isSubmitted = false;
  bool isCorrect = false;
  bool isTransitioning = false; // New state for transition

  // Animation controller
  late AnimationController _animationController;
  late Animation<Offset> _slideOutAnimation;
  late Animation<Offset> _slideInAnimation;

  @override
  void initState() {
    super.initState();
    NavBarSignals.isVisible.value = false;

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _slideOutAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1.0, 0.0),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideInAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    NavBarSignals.isVisible.value = true;
    _animationController.dispose();
    totalPoints.dispose();
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
      isSubmitted = true;
      isCorrect = selectedAnswer == correctAnswer;
    });
  }

  void _evaluateSpeech(int index) async {
    // Simulate speech evaluation (replace with actual TTS logic)
    bool isCorrect = index % 2 == 0; // Placeholder logic

    setState(() {
      speakingResults[index.toString()] = isCorrect;
    });
  }

  void _transitionToSpeakingMode() {
    setState(() {
      isTransitioning = true;
    });

    _animationController.forward().then((_) {
      setState(() {
        isSpeakingMode = true;
        isTransitioning = false;
      });

      _animationController.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        bool exit = await _onBackPressed();
        if (exit && context.mounted) Navigator.pop(context);
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 8),
              _buildCustomHeader(context),
              const SizedBox(height: 8),
              _buildHeader(context),
              const SizedBox(height: 8),
              ClipRRect(
                child: LinearProgressIndicator(
                  value: completedExercises / totalExercises,
                  backgroundColor: theme.colorScheme.border,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.wordColor,
                  ),
                  minHeight: 1,
                ),
              ),
              const SizedBox(height: 64),

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
    );
  }

  // New custom header widget
  Widget _buildCustomHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Exercise title on the left
          // Text(
          //   'Intermediate',
          //   style: theme.textTheme.h4.copyWith(
          //     color: theme.colorScheme.foreground,
          //   ),
          // ),

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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Points & Progress in the same row (opposite sides)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Icon(
              //       LucideIcons.star,
              //       color: ShadTheme.of(context).colorScheme.foreground,
              //       size: 16,
              //     ),
              //     const SizedBox(width: 6),
              //     Text("$totalPoints Points", style: theme.textTheme.p),
              //   ],
              // ),
              totalPoints.ui(context),

              Text(
                "Stage: $completedExercises/$totalExercises",
                style: theme.textTheme.p,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildPointsWidget(
    BuildContext context,
    int points, {
    int? previousPoints,
  }) {
    final theme = ShadTheme.of(context);

    // Use previous points as starting value if provided, otherwise start from current points
    previousPoints = previousPoints ?? points;

    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: previousPoints, end: points),
      duration: Duration(milliseconds: 800),
      builder: (BuildContext context, int animatedPoints, Widget? child) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.star,
              color: theme.colorScheme.foreground,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text("$animatedPoints Points", style: theme.textTheme.p),
          ],
        );
      },
    );
  }

  Widget _buildPracticeContent(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        );
      },
      child:
          isTransitioning
              ? const SizedBox.shrink() // Empty widget during transition
              : isSpeakingMode
              ? _buildSpeakingUI(context)
              : _buildWordUI(context),
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
            isCorrect ? LucideIcons.circleCheck : LucideIcons.circleX,
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

  Widget _buildWordUI(BuildContext context) {
    final theme = ShadTheme.of(context);

    return SlideTransition(
      position: _slideOutAnimation,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          key: const ValueKey("word_ui"),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              'Complete the sentence:',
              style: theme.textTheme.p.copyWith(
                color: theme.colorScheme.foreground.withAlpha(180),
              ),
            ),
            const SizedBox(height: 24),

            SentenceWithBlankWidget(
              sentence: sentence,
              wordToBlank: correctAnswer,
              textStyle: const TextStyle(
                fontSize: 20,
                height: 1.4,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            Column(
              children: List.generate(options.length, (index) {
                String option = options[index];
                bool isSelected = selectedAnswer == option;
                bool isCorrectOption = isSubmitted && option == correctAnswer;
                bool isIncorrectOption =
                    isSubmitted && isSelected && option != correctAnswer;

                return GestureDetector(
                  onTap: () {
                    if (!isSubmitted) {
                      setState(() => selectedAnswer = option);
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    margin: EdgeInsets.only(
                      top: 6,
                      bottom: 6,
                      left: index * 2.0,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color:
                          isCorrectOption
                              ? AppColors.successColor.withAlpha(25)
                              : isIncorrectOption
                              ? AppColors.errorColor.withAlpha(25)
                              : theme.colorScheme.background,
                      border: Border.all(
                        color:
                            isCorrectOption
                                ? AppColors.successColor
                                : isIncorrectOption
                                ? AppColors.errorColor
                                : isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.border,
                        width: 1.5,
                      ),
                      boxShadow: [
                        if (!isSubmitted && !isSelected)
                          BoxShadow(
                            color: theme.colorScheme.border.withAlpha(55),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        else if (isSelected && !isSubmitted)
                          BoxShadow(
                            color: theme.colorScheme.primary.withAlpha(80),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          option,
                          style: theme.textTheme.p.copyWith(
                            color:
                                isCorrectOption
                                    ? AppColors.successColor
                                    : isIncorrectOption
                                    ? AppColors.errorColor
                                    : theme.colorScheme.foreground,
                            fontWeight:
                                isSelected ||
                                        isCorrectOption ||
                                        isIncorrectOption
                                    ? FontWeight.w500
                                    : FontWeight.normal,
                          ),
                        ),
                        if (isSubmitted &&
                            (isCorrectOption || isIncorrectOption))
                          Icon(
                            isCorrectOption ? LucideIcons.check : LucideIcons.x,
                            size: 18,
                            color:
                                isCorrectOption
                                    ? AppColors.successColor
                                    : AppColors.errorColor,
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 8),

            if (isSubmitted) _buildFeedbackContainer(context),

            const SizedBox(height: 16),

            ShadButton(
              height: 44,
              onPressed: () {
                totalPoints.increase(10);
                if (!isSubmitted) {
                  checkAnswer();
                } else {
                  _transitionToSpeakingMode();
                }
              },
              child: Text(isSubmitted ? "To Speaking Mode" : "Submit"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeakingUI(BuildContext context) {
    final theme = ShadTheme.of(context);
    List<String> sentenceParts = [
      "She is",
      "very resilient",
      "after setbacks",
      "She is very resilient after setbacks",
    ];

    return SlideTransition(
      position:
          isTransitioning
              ? _slideInAnimation
              : const AlwaysStoppedAnimation<Offset>(Offset.zero),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          key: const ValueKey("speaking_ui"),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              "Read aloud each part:",
              style: theme.textTheme.p.copyWith(
                color: theme.colorScheme.foreground.withAlpha(180),
              ),
            ),
            const SizedBox(height: 24),

            Column(
              children: List.generate(sentenceParts.length, (index) {
                String part = sentenceParts[index];
                bool? result = speakingResults[index.toString()];
                bool passed = result == true;
                bool failed = result == false;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.only(
                    top: 6,
                    bottom: 6,
                    left: index * 2.0, // Slightly staggered layout
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color:
                        passed
                            ? AppColors.successColor.withAlpha(25)
                            : failed
                            ? AppColors.errorColor.withAlpha(25)
                            : theme.colorScheme.background,
                    border: Border.all(
                      color:
                          passed
                              ? AppColors.successColor
                              : failed
                              ? AppColors.errorColor
                              : theme.colorScheme.border,
                      width: 1.5,
                    ),
                    boxShadow: [
                      if (!passed && !failed)
                        BoxShadow(
                          color: theme.colorScheme.border.withAlpha(75),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Sentence Part
                      Expanded(
                        child: Text(
                          part,
                          style: theme.textTheme.p.copyWith(
                            color:
                                passed
                                    ? AppColors.successColor
                                    : failed
                                    ? AppColors.errorColor
                                    : theme.colorScheme.foreground,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: IconButton(
                          icon: Icon(
                            !passed ? LucideIcons.mic : LucideIcons.circleCheck,
                            size: 22,
                            color:
                                !passed
                                    ? theme.colorScheme.foreground
                                    : AppColors.successColor,
                          ),
                          onPressed:
                              !passed ? () => _evaluateSpeech(index) : null,
                          padding: EdgeInsets.zero, // Remove default padding
                          constraints:
                              const BoxConstraints(), // Remove default constraints
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),

            const SizedBox(height: 16),

            // Finish Button
            ShadButton(
              height: 44,
              onPressed: () {
                // TODO: Handle finishing the speaking session
              },
              child: const Text("Finish"),
            ),
          ],
        ),
      ),
    );
  }
}
