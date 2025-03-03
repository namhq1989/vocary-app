import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:vocary/app/models/word.dart';
import 'package:vocary/app/models/word_example.dart';
import 'package:vocary/app/signals/word_store_signal.dart';
import 'package:vocary/core/design.dart';
import 'package:vocary/resources/widgets/word_ipa_widget.dart';
import 'package:vocary/resources/widgets/word_item_widget.dart';
import 'package:vocary/resources/widgets/word_pos_widget.dart';

final otherWords = [
  Word(
    id: '1',
    word: 'serendipity',
    ipa: '/ˌsɛrənˈdɪpɪti/',
    definitions: [
      'The occurrence of events by chance in a happy or beneficial way.',
    ],
    pos: ['noun', 'adjective'],
    audioUrl: '',
    level: 'Advanced',
    synonyms: ['fluke', 'fortune'],
    antonyms: ['misfortune'],
    examples: [
      WordExample(
        id: '1',
        word: 'serendipity',
        sentence:
            'Serendipity is a term used to describe the occurrence of events by chance that are beneficial or happy',
        audioUrl: 'https://example.com/audio.mp3',
      ),
      WordExample(
        id: '2',
        word: 'serendipity',
        sentence:
            'The ephemeral nature of social media content makes it difficult to archive',
        audioUrl: 'https://example.com/audio.mp3',
      ),
      WordExample(
        id: '3',
        word: 'serendipity',
        sentence: 'Cherry blossoms are celebrated for their ephemeral beauty',
        audioUrl: 'https://example.com/audio.mp3',
      ),
    ],
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
      appBar: AppBar(
        title: Text(word.word),
        actions: [
          InkWell(
            onTap: () {
              print('Tapped on Favorite icon');
            },
            child: Icon(LucideIcons.star),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, word),
              const SizedBox(height: 24),
              _buildStats(context, word),
              const SizedBox(height: 24),
              _buildExamples(context, word),
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              word.word,
              style: ShadTheme.of(
                context,
              ).textTheme.h2.copyWith(color: AppColors.wordColor),
            ),
            const SizedBox(width: 16),
            InkWell(
              onTap: () {
                print('Tapped on sound icon');
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.wordColor.withAlpha(150),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(12),
                child: Icon(LucideIcons.volume2, size: 20, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        WordIpaWidget(ipa: word.ipa, size: 18),
        const SizedBox(height: 8),
        Row(
          children: [
            for (var pos in word.pos) ...[
              WordPosWidget(pos: pos),
              const SizedBox(width: 4),
            ],
          ],
        ),
        const SizedBox(height: 16),
        ...word.definitions.map(
          (definition) => Column(
            children: [
              Text(
                definition,
                style: ShadTheme.of(context).textTheme.p.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExamples(BuildContext context, Word word) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Examples', style: ShadTheme.of(context).textTheme.h3),
        const SizedBox(height: 16),
        ...word.examples.map(
          (example) => Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      example.sentence,
                      style: ShadTheme.of(context).textTheme.p,
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {},
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: Center(
                        child: Icon(
                          LucideIcons.volume2,
                          color: ShadTheme.of(context).colorScheme.foreground,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
            ],
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
              label: 'Attempts',
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
          Expanded(
            child: _buildStatColumn(
              context: context,
              icon: LucideIcons.graduationCap,
              iconColor: AppColors.masteredColor,
              value: '${word.currentStreak}/${word.masteryThreshold}',
              label: 'Mastery',
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
