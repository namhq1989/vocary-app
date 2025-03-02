import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:vocary/app/controllers/practice_controller.dart';
import 'package:vocary/core/design.dart';

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

  int _correctAnswers = 0;
  double _averageAccuracy = 0.0;
  int _totalExercises = 0;
  int _masteredWords = 0;

  @override
  void initState() {
    super.initState();

    // Calculate summary statistics
    _calculateStats();

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
    // Use Watch to access the session signal
    final session = PracticeController().session.value;
    if (session == null) return;

    _totalExercises = session.exercises.length;

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

      // Count mastered words (assuming a word is mastered if both phases are correct)
      if (exercise.fillPhase != null &&
          exercise.speakPhase != null &&
          exercise.fillPhase!.isCorrect &&
          exercise.speakPhase!.parts.every((part) => part.isCorrect)) {
        _masteredWords++;
      }
    }

    // Calculate total correct answers
    _correctAnswers = correctFills + correctSpeaks;

    // Calculate accuracy (considering both fill and speak phases)
    final totalPossibleCorrect = _totalExercises + totalSpeakParts;
    _averageAccuracy =
        totalPossibleCorrect > 0
            ? (correctFills + correctSpeaks) / totalPossibleCorrect * 100
            : 0.0;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeInAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),

                // Total points earned
                _buildPointsSection(context),

                const SizedBox(height: 32),

                // Stats Cards
                _buildStatsSection(context),

                const SizedBox(height: 32),

                // Accuracy gauge
                _buildAccuracySection(context),

                const SizedBox(height: 32),

                // Learning Streak
                _buildStreakSection(context),

                const SizedBox(height: 32),

                // Action buttons
                _buildActionButtons(context),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Practice Complete!',
          style: theme.textTheme.h3.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Here\'s how you did:',
          style: theme.textTheme.p.copyWith(
            color: theme.colorScheme.foreground.withAlpha(180),
          ),
        ),
      ],
    );
  }

  Widget _buildPointsSection(BuildContext context) {
    final theme = ShadTheme.of(context);
    final session = PracticeController().session.value;
    final totalPoints = session?.totalPoints ?? 0;

    return ShadCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(LucideIcons.trophy, color: AppColors.wordColor, size: 28),
                const SizedBox(width: 8),
                Text(
                  'Great Job!',
                  style: theme.textTheme.h4.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$totalPoints',
                  style: theme.textTheme.h1.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.wordColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'points earned',
              style: theme.textTheme.p.copyWith(
                color: theme.colorScheme.foreground.withAlpha(180),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Performance',
          style: theme.textTheme.h4.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                '$_correctAnswers',
                'Correct Answers',
                LucideIcons.circleCheck,
                AppColors.successColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                context,
                '$_totalExercises',
                'Total Exercises',
                LucideIcons.layoutGrid,
                theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                '$_masteredWords',
                'Words Mastered',
                LucideIcons.star,
                AppColors.wordColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                context,
                '2:30', // Fixed time for demo
                'Time Spent',
                LucideIcons.clock,
                theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String value,
    String label,
    IconData icon,
    Color iconColor,
  ) {
    final theme = ShadTheme.of(context);

    return ShadCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: iconColor.withAlpha(25),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: theme.textTheme.h4.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    label,
                    style: theme.textTheme.p.copyWith(
                      color: theme.colorScheme.foreground.withAlpha(180),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccuracySection(BuildContext context) {
    final theme = ShadTheme.of(context);

    // Determine color based on accuracy
    Color gaugeColor = AppColors.errorColor;
    if (_averageAccuracy >= 80) {
      gaugeColor = AppColors.successColor;
    } else if (_averageAccuracy >= 60) {
      gaugeColor = AppColors.wordColor;
    } else if (_averageAccuracy >= 40) {
      gaugeColor = Colors.orange;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Accuracy',
          style: theme.textTheme.h4.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 16),
        ShadCard(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${_averageAccuracy.toStringAsFixed(1)}%',
                      style: theme.textTheme.h2.copyWith(
                        color: gaugeColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Accuracy gauge bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _averageAccuracy / 100,
                    backgroundColor: theme.colorScheme.border,
                    valueColor: AlwaysStoppedAnimation<Color>(gaugeColor),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 16),
                // Gauge labels
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Needs Work',
                      style: theme.textTheme.p.copyWith(
                        color: theme.colorScheme.foreground.withAlpha(180),
                      ),
                    ),
                    Text(
                      'Perfect',
                      style: theme.textTheme.p.copyWith(
                        color: theme.colorScheme.foreground.withAlpha(180),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStreakSection(BuildContext context) {
    final theme = ShadTheme.of(context);

    // Get current streak from recent exercises
    final streak = 3; // This would typically come from your app's state

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Learning Streak',
          style: theme.textTheme.h4.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 16),
        ShadCard(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Fire icon with colored background
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    LucideIcons.flame,
                    color: Colors.orange,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '$streak',
                          style: theme.textTheme.h3.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'days',
                          style: theme.textTheme.h4.copyWith(
                            color: theme.colorScheme.foreground.withAlpha(180),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'You\'re on a roll! Keep it up!',
                      style: theme.textTheme.p.copyWith(
                        color: theme.colorScheme.foreground.withAlpha(180),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        ShadButton(
          height: 56,
          onPressed: () {
            // Navigate to review screen
            Navigator.of(context).pop(); // First pop practice screen
            // Then push vocabulary review screen
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(LucideIcons.repeat),
              SizedBox(width: 8),
              Text('Review Words Again'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ShadButton.outline(
          height: 56,
          onPressed: () {
            // Navigate back to home screen
            Navigator.of(context).pop();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(LucideIcons.house),
              SizedBox(width: 8),
              Text('Back to Home'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ShadButton.ghost(
          height: 56,
          onPressed: () {
            // Share results
            // This would typically use a share plugin
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(LucideIcons.share2),
              SizedBox(width: 8),
              Text('Share Your Results'),
            ],
          ),
        ),
      ],
    );
  }
}
