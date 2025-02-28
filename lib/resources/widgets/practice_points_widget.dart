import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class Points {
  int _currentPoints;
  int? _previousPoints;
  final ValueNotifier<int> _pointsNotifier;

  /// Creates a Points object with an initial value.
  Points(int initialPoints)
    : _currentPoints = initialPoints,
      _pointsNotifier = ValueNotifier(initialPoints);

  /// Gets the current points value.
  int get value => _currentPoints;

  /// Updates the points value while saving the previous one.
  void set(int newPoints) {
    if (newPoints < 0 || newPoints == _currentPoints) return;

    _previousPoints = _currentPoints;
    _currentPoints = newPoints;
    _pointsNotifier.value = _currentPoints;
  }

  /// Disposes the notifier when it's no longer needed.
  void dispose() {
    _pointsNotifier.dispose();
  }

  /// **Displays the points with animation**
  Widget show(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _pointsNotifier,
      builder: (context, points, _) {
        return _AnimatedPointsWidget(
          points: points,
          previousPoints: _previousPoints,
        );
      },
    );
  }
}

class _AnimatedPointsWidget extends StatelessWidget {
  final int points;
  final int? previousPoints;

  const _AnimatedPointsWidget({required this.points, this.previousPoints});

  @override
  Widget build(BuildContext context) {
    if (previousPoints == null || previousPoints == points) {
      return _buildPointsRow(context, points);
    }

    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: previousPoints!, end: points),
      duration: const Duration(milliseconds: 500),
      builder: (context, animatedPoints, _) {
        return _buildPointsRow(context, animatedPoints);
      },
    );
  }

  Widget _buildPointsRow(BuildContext context, int pointsToShow) {
    final theme = ShadTheme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(LucideIcons.star, color: theme.colorScheme.foreground, size: 16),
        const SizedBox(width: 6),
        Text("$pointsToShow Points", style: theme.textTheme.p),
      ],
    );
  }
}
