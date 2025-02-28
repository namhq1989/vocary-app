import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:vocary/app/models/word.dart';
import 'package:vocary/app/signals/word_store_signal.dart';
import 'package:vocary/core/design.dart';
import 'package:vocary/resources/widgets/word_item_widget.dart';

final otherWords = [
  Word(
    id: '1',
    word: 'Serendipity',
    ipa: '/ˌsɛrənˈdɪpɪti/',
    definitions: [
      'The occurrence of events by chance in a happy or beneficial way.',
    ],
    pos: ['noun'],
    audioUrl: '',
    level: 'Advanced',
    synonyms: ['fluke', 'fortune'],
    antonyms: ['misfortune'],
    examples: [],
    isFavorite: false,
    isMastered: false,
    currentStreak: 2,
    masteryThreshold: 5,
  ),
  Word(
    id: '2',
    word: 'Ubiquitous',
    ipa: '/juːˈbɪkwɪtəs/',
    definitions: ['Present, appearing, or found everywhere.'],
    pos: ['adjective'],
    audioUrl: '',
    level: 'Advanced',
    synonyms: ['omnipresent', 'pervasive'],
    antonyms: ['rare'],
    examples: [],
    isFavorite: false,
    isMastered: true,
    currentStreak: 3,
    masteryThreshold: 5,
  ),
  Word(
    id: '3',
    word: 'Ephemeral',
    ipa: '/ɪˈfɛmərəl/',
    definitions: ['Lasting for a very short time.'],
    pos: ['adjective'],
    audioUrl: '',
    level: 'Advanced',
    synonyms: ['transitory', 'fleeting'],
    antonyms: ['permanent'],
    examples: [],
    isFavorite: false,
    isMastered: false,
    currentStreak: 0,
    masteryThreshold: 5,
  ),
  Word(
    id: '4',
    word: 'Resilient',
    ipa: '/rɪˈzɪl.jənt/',
    definitions: ['Able to recover quickly from difficulties.'],
    pos: ['adjective'],
    audioUrl: '',
    level: 'Intermediate',
    synonyms: ['strong', 'tough'],
    antonyms: ['fragile'],
    examples: [],
    isFavorite: false,
    isMastered: true,
    currentStreak: 5,
    masteryThreshold: 5,
  ),
  Word(
    id: '5',
    word: 'Eloquent',
    ipa: '/ˈɛləkwənt/',
    definitions: ['Fluent or persuasive in speaking or writing.'],
    pos: ['adjective'],
    audioUrl: '',
    level: 'Intermediate',
    synonyms: ['expressive', 'articulate'],
    antonyms: ['inarticulate'],
    examples: [],
    isFavorite: false,
    isMastered: false,
    currentStreak: 1,
    masteryThreshold: 5,
  ),
];

class WordDetailScreen extends StatelessWidget {
  final String wordId;

  const WordDetailScreen({super.key, required this.wordId});

  @override
  Widget build(BuildContext context) {
    final word = WordStoreSignals.getWord(wordId);
    if (word == null) {
      return const Scaffold(body: Center(child: Text('Word not found')));
    }

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
            if (word.isMastered)
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
        Text(word.definitions[0], style: ShadTheme.of(context).textTheme.p),
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
            return WordItemWidget(wordId: otherWords[index].id);
          },
        ),
      ],
    );
  }
}
