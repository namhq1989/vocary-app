import 'dart:math';

/// Class containing text options for summary screen based on accuracy
class PracticeSummaryTextOptions {
  /// Returns a random header text based on the accuracy percentage
  static String getRandomHeaderText(int accuracy) {
    final random = Random();

    if (accuracy >= 90) {
      // Excellent tier (90-100%)
      final options = [
        'Outstanding',
        'Excellent Work',
        'Brilliant',
        'Exceptional',
        'Superb Performance',
      ];
      return options[random.nextInt(options.length)];
    } else if (accuracy >= 80) {
      // Great tier (80-89%)
      final options = [
        'Great Job',
        'Well Done',
        'Impressive',
        'Fantastic',
        'Achievement Unlocked',
      ];
      return options[random.nextInt(options.length)];
    } else if (accuracy >= 60) {
      // Good tier (60-79%)
      final options = [
        'Good Progress',
        'Nice Work',
        'Keep It Up',
        'Solid Effort',
        'Getting Better',
      ];
      return options[random.nextInt(options.length)];
    } else {
      // Needs improvement tier (below 60%)
      final options = [
        'Getting Started',
        'Room to Grow',
        'Practice Makes Perfect',
        'Keep Practicing',
        'You\'ll Get There',
      ];
      return options[random.nextInt(options.length)];
    }
  }

  /// Returns a random title text based on the accuracy percentage
  static String getRandomTitleText(int accuracy) {
    final random = Random();

    if (accuracy >= 80) {
      // High performance titles
      final options = [
        'Session Complete',
        'Learning Goal Achieved',
        'Skills Strengthened',
        'Vocabulary Mastered',
        'Knowledge Enhanced',
      ];
      return options[random.nextInt(options.length)];
    } else {
      // Lower performance but encouraging titles
      final options = [
        'Session Complete',
        'Progress Made',
        'Keep Building Your Skills',
        'Growth In Progress',
        'Continue Your Journey',
      ];
      return options[random.nextInt(options.length)];
    }
  }

  /// Returns a random motivational message based on the accuracy percentage
  static String getRandomMotivationalMessage(double accuracy) {
    final random = Random();

    if (accuracy >= 90) {
      final options = [
        'You\'re mastering these words at an impressive rate',
        'Your dedication is really paying off',
        'You\'re a natural language learner',
        'Keep up this excellent performance',
        'Your vocabulary is expanding rapidly',
      ];
      return options[random.nextInt(options.length)];
    } else if (accuracy >= 80) {
      final options = [
        'You\'re making great progress with your vocabulary',
        'Your practice is clearly paying off',
        'You\'re well on your way to mastery',
        'Consistent effort brings consistent results',
        'Great job on building your language skills',
      ];
      return options[random.nextInt(options.length)];
    } else if (accuracy >= 60) {
      final options = [
        'Regular practice will help these words stick',
        'You\'re making progress with each session',
        'Keep going - consistency is key to mastery',
        'Each practice session builds your skills',
        'You\'re on the right track to improvement',
      ];
      return options[random.nextInt(options.length)];
    } else {
      final options = [
        'Every word learned is a step forward',
        'Language learning takes time - keep at it',
        'Progress happens with persistent practice',
        'Don\'t give up - improvement comes with practice',
        'Learning new words takes repetition - you\'ll get there',
      ];
      return options[random.nextInt(options.length)];
    }
  }
}
