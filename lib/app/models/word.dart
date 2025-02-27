class Word {
  final String word;
  final String meaning;
  final String ipa;
  final List<String> pos;
  final String level;
  final bool mastered;
  final int currentStreak;
  final int maxStreak;

  Word({
    required this.word,
    required this.meaning,
    required this.ipa,
    required this.pos,
    required this.level,
    this.mastered = false,
    this.currentStreak = 0,
    this.maxStreak = 0,
  });
}
