import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class Points {
  int _currentPoints;
  int? _previousPoints;
  final ValueNotifier<int> _pointsNotifier;

  /// Creates a Points object with initial value
  Points(int initialPoints)
    : _currentPoints = initialPoints,
      _pointsNotifier = ValueNotifier(initialPoints);

  /// Get the current points value
  int get value => _currentPoints;

  /// Increase points by the specified amount
  void increase(int amount) {
    if (amount <= 0) return;

    _previousPoints = _currentPoints;
    _currentPoints += amount;
    _pointsNotifier.value = _currentPoints;
  }

  /// Decrease points by the specified amount
  void decrease(int amount) {
    if (amount <= 0) return;

    _previousPoints = _currentPoints;
    _currentPoints =
        (_currentPoints - amount).clamp(0, double.infinity).toInt();
    _pointsNotifier.value = _currentPoints;
  }

  /// Set points to a specific value
  void set(int newPoints) {
    if (newPoints < 0 || newPoints == _currentPoints) return;

    _previousPoints = _currentPoints;
    _currentPoints = newPoints;
    _pointsNotifier.value = _currentPoints;
  }

  /// Returns a widget that displays the points with animation
  Widget ui(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _pointsNotifier,
      builder: (context, points, _) {
        return _PointsWidget(points: points, previousPoints: _previousPoints);
      },
    );
  }

  /// Dispose the notifier when no longer needed
  void dispose() {
    _pointsNotifier.dispose();
  }
}

class _PointsWidget extends StatefulWidget {
  final int points;
  final int? previousPoints;

  const _PointsWidget({required this.points, this.previousPoints});

  @override
  State<_PointsWidget> createState() => _PointsWidgetState();
}

class _PointsWidgetState extends State<_PointsWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.previousPoints == null ||
        widget.previousPoints == widget.points) {
      return _buildPointsRow(context, widget.points);
    }

    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: widget.previousPoints!, end: widget.points),
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
