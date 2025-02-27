import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:vocary/app/models/word.dart';
import 'package:vocary/core/design.dart';
import 'package:vocary/resources/widgets/word_item_widget.dart';

final word = Word(
  word: 'Dart',
  ipa: '/dɑrt/',
  meaning:
      'A client-optimized programming language for fast apps on any platform. Developed by Google for building mobile, desktop, server, and web applications.',
  pos: ['noun'],
  mastered: true,
  currentStreak: 5,
  maxStreak: 5,
  level: 'Advanced',
);

final otherWords = [
  Word(
    word: 'Mobile',
    ipa: '/ˈmoʊbəl/',
    meaning:
        'Capable of moving or being moved freely or easily. In computing, refers to portable devices like smartphones and tablets.',
    pos: ['adjective', 'noun'],
    mastered: true,
    level: 'Intermediate',
  ),
  Word(
    word: 'Flutter',
    ipa: '/ˈflʌtər/',
    meaning:
        'A popular open-source framework by Google for building beautiful, natively compiled applications for mobile, web, and desktop.',
    pos: ['noun', 'verb'],
    mastered: true,
    level: 'Advanced',
  ),
  Word(
    word: 'Dart',
    ipa: '/dɑrt/',
    meaning:
        'A client-optimized programming language for fast apps on any platform. Developed by Google for building mobile, desktop, server, and web applications.',
    pos: ['noun'],
    mastered: false,
    currentStreak: 3,
    maxStreak: 5,
    level: 'Advanced',
  ),
  Word(
    word: 'App',
    ipa: '/æp/',
    meaning:
        'A self-contained program or piece of software designed to fulfill a particular purpose; an application, especially as downloaded by a user.',
    pos: ['noun'],
    mastered: false,
    currentStreak: 4,
    maxStreak: 5,
    level: 'Beginner',
  ),
  Word(
    word: 'Code',
    ipa: '/koʊd/',
    meaning:
        'Instructions written in a programming language that can be executed by a computer to perform specific tasks and create software.',
    pos: ['noun'],
    mastered: true,
    level: 'Intermediate',
  ),
];

class WordDetailScreen extends StatelessWidget {
  final String wordId;

  const WordDetailScreen({super.key, required this.wordId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(word.word)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, word),
              const SizedBox(height: 16),
              _buildExamples(context, word),
              const SizedBox(height: 24),
              _buildStats(context, word),
              const SizedBox(height: 32),
              _buildOtherWords(context, otherWords),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Word word) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(word.word, style: ShadTheme.of(context).textTheme.h2),
            const SizedBox(width: 8),
            if (word.mastered)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.masteredColor.withAlpha(26),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Mastered',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.masteredColor,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '/ˈsæmpəl/', // Replace with actual IPA from word model
          style: TextStyle(fontSize: 20, fontFamily: 'NotoSans'),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            for (var pos in word.pos) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: ShadTheme.of(
                    context,
                  ).colorScheme.border.withAlpha(127),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: ShadTheme.of(
                      context,
                    ).colorScheme.border.withAlpha(26),
                  ),
                ),
                child: Text(pos, style: TextStyle(fontSize: 11)),
              ),
              const SizedBox(width: 4),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Text(word.meaning, style: ShadTheme.of(context).textTheme.p),
      ],
    );
  }

  Widget _buildExamples(BuildContext context, Word word) {
    final examples = [
      'This is an example sentence using the word "${word.word}".',
      'Another example sentence that helps understand "${word.word}" better.',
      'A third sentence to demonstrate the meaning of "${word.word}".-',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Examples', style: ShadTheme.of(context).textTheme.h3),
        const SizedBox(height: 8),
        ...examples.map(
          (example) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text('• $example', style: ShadTheme.of(context).textTheme.p),
          ),
        ),
      ],
    );
  }

  Widget _buildStats(BuildContext context, Word word) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: _buildStatColumn(
              context: context,
              icon: LucideIcons.penLine,
              iconColor: AppColors.pointsColor,
              value: '${word.currentStreak}',
              label: 'Practiced',
            ),
          ),
          Expanded(
            child: _buildStatColumn(
              context: context,
              icon: LucideIcons.flame,
              iconColor: AppColors.learnedColor,
              value: '${word.currentStreak}',
              label: 'Streak',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: iconColor, size: 32),
        const SizedBox(height: 12),
        Text(value, style: ShadTheme.of(context).textTheme.h1),
        const SizedBox(height: 2),
        Text(label, style: ShadTheme.of(context).textTheme.muted),
      ],
    );
  }

  Widget _buildOtherWords(BuildContext context, List<Word> otherWords) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Other Words', style: ShadTheme.of(context).textTheme.h3),
        const SizedBox(height: 16),
        GridView.builder(
          // padding: const EdgeInsets.symmetric(horizontal: 16),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            mainAxisExtent: 210,
          ),
          itemCount: otherWords.length.clamp(0, 10), // Using unlearned words
          itemBuilder: (context, index) {
            return WordItemWidget(word: otherWords[index]);
          },
        ),
      ],
    );
  }
}
