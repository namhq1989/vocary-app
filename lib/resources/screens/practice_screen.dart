import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:signals/signals_flutter.dart';
import 'package:vocary/app/controllers/practice_controller.dart';
import 'package:vocary/app/models/exercise.dart';
import 'package:vocary/app/models/practice_config.dart';
import 'package:vocary/app/models/practice_fill_phase.dart';
import 'package:vocary/app/models/practice_session.dart';
import 'package:vocary/app/models/practice_speak_phase.dart';
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
  late PracticeController controller;
  late Points totalPoints;
  bool isTransitioning = false;

  int fillPhaseSelectedOptionIndex = -1;

  // Animation controller
  late AnimationController _animationController;
  late Animation<Offset> _slideOutAnimation;
  late Animation<Offset> _slideInAnimation;

  @override
  void initState() {
    super.initState();
    NavBarSignals.isVisible.value = false;

    controller = PracticeController();
    _loadInitialData();

    totalPoints = Points(0);

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

  Future<void> _loadInitialData() async {
    try {
      await controller.initSession(config: PracticeConfig.defaultConfig());
    } catch (error) {
      // Handle any errors during initialization
      if (mounted) {
        // Show error message or take appropriate action
      }
    }
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

  void _transitionToSpeakingMode() {
    setState(() {
      isTransitioning = true;
    });

    _animationController.forward().then((_) {
      setState(() {
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
          child: Watch((context) {
            final isFetching = controller.isFetchingExercises.value;

            if (isFetching) {
              return const Center(child: CircularProgressIndicator());
            }

            final session = controller.session.value;
            if (session == null) {
              return const Center(child: Text('Session not found'));
            }

            final exercise = session.currentExercise;
            if (exercise == null) {
              return const Center(child: Text('Exercise not found'));
            }

            return Column(
              children: [
                const SizedBox(height: 8),
                _buildCustomHeader(context),
                const SizedBox(height: 8),
                _buildHeader(context, session),
                const SizedBox(height: 8),
                ClipRRect(
                  child: LinearProgressIndicator(
                    value: session.completionPercentage,
                    backgroundColor: theme.colorScheme.border,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.wordColor,
                    ),
                    minHeight: 1,
                  ),
                ),
                const SizedBox(height: 48),

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
                        child: _buildPracticeContent(context, exercise),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  // New custom header widget
  Widget _buildCustomHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
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

  Widget _buildHeader(BuildContext context, PracticeSession session) {
    totalPoints.set(session.totalPoints);
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
              totalPoints.show(context),

              Text(
                "Exercise: ${session.completedExercisesCount}/${session.exercises.length}",
                style: theme.textTheme.p,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPracticeContent(BuildContext context, Exercise exercise) {
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
              : exercise.isSpeakPhase
              ? _buildSpeakPhaseUI(context, exercise)
              : _buildFillPhaseUI(context, exercise),
    );
  }

  Widget _buildFillPhaseResult(
    BuildContext context,
    PracticeFillPhase fillPhase,
  ) {
    final theme = ShadTheme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color:
            fillPhase.isCorrect
                ? AppColors.successColor.withAlpha(25)
                : AppColors.errorColor.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            fillPhase.isCorrect ? LucideIcons.circleCheck : LucideIcons.circleX,
            color:
                fillPhase.isCorrect
                    ? AppColors.successColor
                    : AppColors.errorColor,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              fillPhase.isCorrect
                  ? "Great job! You've selected the correct answer."
                  : "Not quite right. The correct answer is '${fillPhase.blankWord}'. Let's keep practicing!",
              style: theme.textTheme.p.copyWith(
                fontWeight: FontWeight.w500,
                color:
                    fillPhase.isCorrect
                        ? AppColors.successColor
                        : AppColors.errorColor,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFillPhaseUI(BuildContext context, Exercise exercise) {
    final fillPhase = exercise.fillPhase!;
    final options = fillPhase.options;
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
              sentence: fillPhase.sentence,
              wordToBlank: fillPhase.blankWord,
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
                bool isSelected = fillPhaseSelectedOptionIndex == index;
                bool isSameWithBlankWord = option == fillPhase.blankWord;
                bool isSameWithUserAnswer = option == fillPhase.userAnswer;

                Color borderColor =
                    fillPhase.isSubmitted
                        ? (fillPhase.isCorrect
                            ? isSameWithBlankWord
                                ? AppColors.successColor
                                : theme.colorScheme.border
                            : isSameWithUserAnswer
                            ? AppColors.errorColor
                            : theme.colorScheme.border)
                        : isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.border;

                bool isCorrectOption =
                    fillPhase.isSubmitted &&
                    fillPhase.isCorrect &&
                    option == fillPhase.blankWord;
                bool isIncorrectOption =
                    fillPhase.isSubmitted &&
                    isSelected &&
                    option != fillPhase.blankWord;

                return GestureDetector(
                  onTap: () {
                    if (!fillPhase.isSubmitted) {
                      setState(() {
                        fillPhaseSelectedOptionIndex = index;
                      });
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
                      color: theme.colorScheme.background,
                      border: Border.all(
                        color:
                            fillPhase.isSubmitted && isSameWithBlankWord
                                ? AppColors.successColor
                                : borderColor,
                        width: 1,
                      ),
                      boxShadow: [
                        if (!fillPhase.isSubmitted && !isSelected)
                          BoxShadow(
                            color: theme.colorScheme.border.withAlpha(55),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        else if (isSelected && !fillPhase.isSubmitted)
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
                        if (fillPhase.isSubmitted &&
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

            if (fillPhase.isSubmitted)
              _buildFillPhaseResult(context, fillPhase),

            const SizedBox(height: 16),

            ShadButton(
              height: 50,
              onPressed: () {
                if (!fillPhase.isSubmitted) {
                  controller.submitFillPhaseAnswer(
                    options[fillPhaseSelectedOptionIndex],
                  );
                  setState(() {
                    fillPhaseSelectedOptionIndex = -1;
                  });
                } else {
                  _transitionToSpeakingMode();
                  controller.toSpeakPhase();
                }
              },
              child: Text(
                fillPhase.isSubmitted ? "To Speaking Mode" : "Submit",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeakPhaseUI(BuildContext context, Exercise exericse) {
    final speakPhase = exericse.speakPhase!;
    final theme = ShadTheme.of(context);

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
              children: List.generate(speakPhase.parts.length, (index) {
                PracticeSpeakingPart part = speakPhase.parts[index];
                final passed = part.isCorrect == true;
                final failed = part.isCorrect == false;

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
                          part.content,
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
                              !passed ? () => part.evaluateSpeech(0.9) : null,
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
              height: 50,
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
