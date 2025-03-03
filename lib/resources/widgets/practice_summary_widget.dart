import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:vocary/app/controllers/practice_controller.dart';
import 'package:vocary/app/utils/practice_summary_text.dart';
import 'package:vocary/core/design.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

/// A widget that displays practice session summary statistics
class PracticeSummaryWidget extends StatefulWidget {
  final PracticeController controller;

  const PracticeSummaryWidget(this.controller, {super.key});

  @override
  State<PracticeSummaryWidget> createState() => _PracticeSummaryWidgetState();
}

class _PracticeSummaryWidgetState extends State<PracticeSummaryWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;
  late ConfettiController _confettiController;

  late String _headerText;
  late String _titleText;

  int _totalExercises = 0;
  int _totalPoints = 0;
  Duration _totalDuration = Duration.zero;
  int _accuracyPercent = 0;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );

    // Calculate stats first
    _calculateStats();

    // Then play confetti after a short delay
    if (_accuracyPercent >= 80) {
      _confettiController.play();
    }

    _headerText = PracticeSummaryTextOptions.getRandomHeaderText(
      _accuracyPercent,
    );
    _titleText = PracticeSummaryTextOptions.getRandomTitleText(
      _accuracyPercent,
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

    // Start animations after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  void _calculateStats() {
    final session = widget.controller.session.value;
    if (session == null) return;

    _totalExercises = session.exercises.length;
    _totalPoints = session.totalPoints;
    _totalDuration = session.totalTimeSpent;
    _accuracyPercent = session.accuracyPercent;
  }

  Path drawStar(Size size) {
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
    _confettiController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Stack(
      children: [
        Align(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2,
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

                      const SizedBox(height: 12),

                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 32),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              LucideIcons.timer,
                              size: 18,
                              color: theme.colorScheme.foreground,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatDuration(_totalDuration),
                              style: theme.textTheme.p.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 48),

                      // Stats row 1
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Points
                          Expanded(
                            child: _buildStatItem(
                              context,
                              LucideIcons.star,
                              'Points',
                              '$_totalPoints',
                              AppColors.pointsColor,
                            ),
                          ),

                          const SizedBox(width: 4),

                          // Total Exercises
                          Expanded(
                            child: _buildStatItem(
                              context,
                              LucideIcons.layoutGrid,
                              'Exercises',
                              '$_totalExercises',
                              AppColors.learnedColor,
                            ),
                          ),

                          const SizedBox(width: 4),

                          // Accuracy
                          Expanded(
                            child: _buildStatItem(
                              context,
                              LucideIcons.percent,
                              'Accuracy',
                              '$_accuracyPercent',
                              _accuracyPercent >= 80
                                  ? AppColors.successColor
                                  : AppColors.errorColor,
                            ),
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

    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
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
            style: theme.textTheme.h3.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            label,
            style: theme.textTheme.p.copyWith(
              color: theme.colorScheme.foreground.withAlpha(180),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
