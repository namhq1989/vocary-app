import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:signals/signals_flutter.dart';
import 'package:vocary/app/controllers/practice_controller.dart';
import 'package:vocary/app/models/exercise.dart';
import 'package:vocary/app/models/practice_config.dart';
import 'package:vocary/app/models/practice_session.dart';
import 'package:vocary/app/models/practice_speak_phase.dart';
import 'package:vocary/app/signals/navbar_signal.dart';
import 'package:vocary/core/design.dart';
import 'package:vocary/core/logger.dart';
import 'package:vocary/resources/widgets/practice_points_widget.dart';
import 'package:vocary/resources/widgets/practice_summary_widget.dart';
import 'package:vocary/resources/widgets/sentence_with_blank_widget.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen>
    with TickerProviderStateMixin {
  late PracticeController controller;
  late Points totalPoints;
  bool isTransitioning = false;

  int fillPhaseSelectedOptionIndex = -1;
  double _currentProgressValue = 0.0;

  bool _isShowingSummary = false;
  bool _isLoadingSummary = false;

  // Animation controllers
  late AnimationController _animationController;
  late Animation<Offset> _slideOutAnimation;
  late Animation<Offset> _slideInAnimation;
  late AnimationController _progressAnimationController;
  late Animation<double> _progressAnimation;

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

    _progressAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _progressAnimationController,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void didUpdateWidget(PracticeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    totalPoints.dispose();
    totalPoints = Points(0);
  }

  @override
  void dispose() {
    NavBarSignals.isVisible.value = true;
    _animationController.dispose();
    _progressAnimationController.dispose();
    totalPoints.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    try {
      await controller.initSession(config: PracticeConfig.defaultConfig());

      if (mounted && controller.session.value != null) {
        setState(() {
          _currentProgressValue = controller.session.value!.completionRatio;
        });
      }
    } catch (error) {
      Log.e(error);
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

  void _showSummary() {
    setState(() {
      _isLoadingSummary = true;
    });

    Timer(const Duration(milliseconds: 2000), () {
      setState(() {
        _isLoadingSummary = false;
        _isShowingSummary = true;
      });
    });
  }

  void _transitionToNextExercise() {
    setState(() {
      isTransitioning = true;
    });

    _animationController.forward().then((_) {
      controller.startExercise();

      setState(() {
        isTransitioning = false;
        fillPhaseSelectedOptionIndex = -1;
      });

      _animationController.reset();
    });
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

  void _animateProgressBar(double targetValue) {
    // Update the animation with current value as the start point
    _progressAnimation = Tween<double>(
      begin: _currentProgressValue,
      end: targetValue,
    ).animate(
      CurvedAnimation(
        parent: _progressAnimationController,
        curve: Curves.easeOut,
      ),
    );

    // Update the current value for next animation
    _currentProgressValue = targetValue;

    // Reset and run the animation
    _progressAnimationController.reset();
    _progressAnimationController.forward();
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

            // If summary is being loaded, show loading animation
            if (_isLoadingSummary) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Calculating results...',
                      style: theme.textTheme.p.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }

            // If summary should be shown, display the summary widget
            if (_isShowingSummary) {
              return const PracticeSummaryWidget();
            }

            return Column(
              children: [
                const SizedBox(height: 8),
                _buildCustomHeader(context),
                const SizedBox(height: 8),
                _buildHeader(context, session),
                const SizedBox(height: 8),

                AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    final value =
                        _progressAnimationController.isAnimating
                            ? _progressAnimation.value
                            : _currentProgressValue;

                    return ClipRRect(
                      child: LinearProgressIndicator(
                        value: value,
                        backgroundColor: theme.colorScheme.border,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.wordColor,
                        ),
                        minHeight: 1,
                      ),
                    );
                  },
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

  Widget _buildCurrentPhaseUI(BuildContext context, Exercise exercise) {
    return exercise.isSpeakPhase
        ? _buildSpeakPhaseUI(context, exercise)
        : _buildFillPhaseUI(context, exercise);
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
      child: _buildCurrentPhaseUI(context, exercise),
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
                            isCorrectOption
                                ? LucideIcons.circleCheck
                                : LucideIcons.x,
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

            const SizedBox(height: 16),

            ShadButton(
              enabled:
                  fillPhase.isSubmitted || fillPhaseSelectedOptionIndex != -1,
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

  Widget _buildSpeakPhaseUI(BuildContext context, Exercise exercise) {
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

            // Use Watch here to make sure this column rebuilds when the exercise changes
            Watch((context) {
              // Force a rebuild of this part of the UI when controller.session changes
              final currentExercise = controller.session.value?.currentExercise;
              if (currentExercise == null ||
                  currentExercise.id != exercise.id) {
                return const SizedBox.shrink();
              }

              final updatedSpeakPhase = currentExercise.speakPhase!;

              return Column(
                children: List.generate(updatedSpeakPhase.parts.length, (
                  index,
                ) {
                  PracticeSpeakingPart part = updatedSpeakPhase.parts[index];

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
                      color: theme.colorScheme.background,
                      border: Border.all(
                        color:
                            part.isSubmitted
                                ? part.isCorrect
                                    ? AppColors.successColor
                                    : AppColors.errorColor
                                : theme.colorScheme.border,
                        width: 1,
                      ),
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
                              color: theme.colorScheme.foreground,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: IconButton(
                            icon: Icon(
                              !part.isCorrect
                                  ? LucideIcons.mic
                                  : LucideIcons.circleCheck,
                              size: 22,
                              color:
                                  !part.isCorrect
                                      ? theme.colorScheme.foreground
                                      : AppColors.successColor,
                            ),
                            onPressed:
                                !part.isCorrect
                                    ? () => controller.submitSpeakPhasePart(
                                      index,
                                      0.9,
                                    )
                                    : null,
                            padding: EdgeInsets.zero, // Remove default padding
                            constraints:
                                const BoxConstraints(), // Remove default constraints
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              );
            }),

            const SizedBox(height: 16),

            ShadButton(
              height: 50,
              onPressed: () {
                int completedCountBefore =
                    controller.session.value!.completedExercisesCount;
                int totalExercises = controller.session.value!.exercises.length;

                double targetRatio =
                    (completedCountBefore + 1) / totalExercises;

                bool isMovingToFinalExercise =
                    completedCountBefore == totalExercises - 2;

                controller.toNextExercise();
                _animateProgressBar(targetRatio);

                final isLastExercise =
                    completedCountBefore >= totalExercises - 1;
                if (isLastExercise) {
                  controller.session.value?.complete();
                  _showSummary();
                } else if (!isMovingToFinalExercise &&
                    !controller.isOnFinalExercise) {
                  _transitionToNextExercise();
                } else if (isMovingToFinalExercise) {
                  _transitionToNextExercise();
                }
              },
              child: Text("Complete"),
            ),
          ],
        ),
      ),
    );
  }
}
