class Word {
  final String word;
  final String meaning;
  final String ipa;
  final List<String> pos;
  final String level;
  final bool mastered;
  final int streak;
  final int required;

  Word({
    required this.word,
    required this.meaning,
    required this.ipa,
    required this.pos,
    required this.level,
    this.mastered = false,
    this.streak = 0,
    this.required = 5,
  });
}
