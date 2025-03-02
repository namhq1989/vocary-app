import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:vocary/app/controllers/practice_controller.dart';
import 'package:vocary/app/utils/practice_summary_text.dart';
import 'package:vocary/core/design.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

/// A widget that displays practice session summary statistics
class PracticeSummaryWidget extends StatefulWidget {
  const PracticeSummaryWidget({super.key});

  @override
  State<PracticeSummaryWidget> createState() => _PracticeSummaryWidgetState();
}

class _PracticeSummaryWidgetState extends State<PracticeSummaryWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;
  late ConfettiController _leftConfettiController;
  late ConfettiController _rightConfettiController;

  late String _headerText;
  late String _titleText;

  double _averageAccuracy = 80;
  int _totalExercises = 10;
  int _totalPoints = 120;

  @override
  void initState() {
    super.initState();

    // Calculate summary statistics
    _calculateStats();

    _headerText = PracticeSummaryTextOptions.getRandomHeaderText(
      _averageAccuracy,
    );
    _titleText = PracticeSummaryTextOptions.getRandomTitleText(
      _averageAccuracy,
    );

    // Initialize animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeInAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // Initialize confetti controllers with 1 second duration
    _leftConfettiController = ConfettiController(
      duration: const Duration(seconds: 1),
    );

    _rightConfettiController = ConfettiController(
      duration: const Duration(seconds: 1),
    );

    // Start animations after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();

      // Play confetti if accuracy is high enough
      if (_averageAccuracy >= 80) {
        _leftConfettiController.play();
        _rightConfettiController.play();
      }
    });
  }

  void _calculateStats() {
    // Use session signal to access data
    final session = PracticeController().session.value;
    if (session == null) return;

    _totalExercises = session.exercises.length;
    _totalPoints = session.totalPoints;

    int correctFills = 0;
    int correctSpeaks = 0;
    int totalSpeakParts = 0;

    for (final exercise in session.exercises) {
      // Count correct fill phases
      if (exercise.fillPhase != null && exercise.fillPhase!.isCorrect) {
        correctFills++;
      }

      // Count correct speaking parts
      if (exercise.speakPhase != null) {
        final correctParts =
            exercise.speakPhase!.parts.where((part) => part.isCorrect).length;
        correctSpeaks += correctParts;
        totalSpeakParts += exercise.speakPhase!.parts.length;
      }
    }

    // Calculate accuracy (considering both fill and speak phases)
    final totalPossibleCorrect = _totalExercises + totalSpeakParts;
    _averageAccuracy =
        totalPossibleCorrect > 0
            ? (correctFills + correctSpeaks) / totalPossibleCorrect * 100
            : 0.0;
  }

  Path drawStar(Size size) {
    // Method to convert degrees to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(
        halfWidth + externalRadius * cos(step),
        halfWidth + externalRadius * sin(step),
      );
      path.lineTo(
        halfWidth + internalRadius * cos(step + halfDegreesPerStep),
        halfWidth + internalRadius * sin(step + halfDegreesPerStep),
      );
    }
    path.close();
    return path;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _leftConfettiController.dispose();
    _rightConfettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Stack(
      children: [
        // Left side confetti
        Align(
          alignment: const Alignment(-0.3, -1),
          child: ConfettiWidget(
            confettiController: _leftConfettiController,
            blastDirection: pi / 2, // Downward
            blastDirectionality: BlastDirectionality.explosive,
            emissionFrequency: 0.08,
            numberOfParticles: 15,
            maxBlastForce: 30,
            minBlastForce: 15,
            gravity: 0.4,
            particleDrag: 0.2,
            createParticlePath: drawStar,
            colors: const [
              Colors.red,
              Colors.blue,
              Colors.green,
              Colors.yellow,
              Colors.purple,
              Colors.orange,
            ],
          ),
        ),

        // Right side confetti
        Align(
          alignment: const Alignment(0.3, -1),
          child: ConfettiWidget(
            confettiController: _rightConfettiController,
            blastDirection: pi / 2, // Downward
            blastDirectionality: BlastDirectionality.explosive,
            emissionFrequency: 0.08,
            numberOfParticles: 15,
            maxBlastForce: 30,
            minBlastForce: 15,
            gravity: 0.4,
            particleDrag: 0.2,
            createParticlePath: drawStar,
            colors: const [
              Colors.red,
              Colors.blue,
              Colors.green,
              Colors.yellow,
              Colors.purple,
              Colors.orange,
            ],
          ),
        ),

        // Main content
        FadeTransition(
          opacity: _fadeInAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 32.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Big icon with light rounded background
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: AppColors.wordColor.withAlpha(20),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/images/trophy.svg',
                            width: 80,
                            height: 80,
                            colorFilter: ColorFilter.mode(
                              AppColors.wordColor,
                              BlendMode.srcIn,
                            ),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Header text
                      Text(
                        _headerText,
                        style: theme.textTheme.h2.copyWith(
                          color: AppColors.wordColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Title text
                      Text(
                        _titleText,
                        style: theme.textTheme.lead.copyWith(fontSize: 18),
                      ),

                      const SizedBox(height: 40),

                      // Stats row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Points
                          _buildStatItem(
                            context,
                            LucideIcons.star,
                            'Points',
                            '$_totalPoints',
                            AppColors.pointsColor,
                          ),

                          // Total Exercises
                          _buildStatItem(
                            context,
                            LucideIcons.layoutGrid,
                            'Exercises',
                            '$_totalExercises',
                            AppColors.learnedColor,
                          ),

                          // Accuracy
                          _buildStatItem(
                            context,
                            LucideIcons.percent,
                            'Accuracy',
                            '${_averageAccuracy.round()}%',
                            _averageAccuracy >= 80
                                ? AppColors.successColor
                                : AppColors.errorColor,
                          ),
                        ],
                      ),

                      const SizedBox(height: 48),

                      // Buttons
                      ShadButton(
                        onPressed: () {
                          // Continue learning action
                        },
                        child: const Text('Continue Learning'),
                      ),

                      const SizedBox(height: 8),

                      ShadButton.outline(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Go Home'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color iconColor,
  ) {
    final theme = ShadTheme.of(context);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: iconColor.withAlpha(25),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.h4.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: theme.textTheme.p.copyWith(
            color: theme.colorScheme.foreground.withAlpha(180),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
