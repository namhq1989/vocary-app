import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:vocary/app/models/word.dart';
import 'package:vocary/core/design.dart';
import 'package:vocary/resources/widgets/practice_config_bottom_sheet.dart';
import 'package:vocary/resources/widgets/word_item_widget.dart';
import 'package:vocary/router/routes.dart';

final List<Word> learnedWords = [
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

final List<Word> notLearnedWords = [
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

class CollectionDetailScreen extends StatelessWidget {
  final String collectionId;

  const CollectionDetailScreen({super.key, required this.collectionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Collection Detail')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        icon: LucideIcons.bookOpen,
                        value: learnedWords.length,
                        label: 'Learned',
                        color: AppColors.learnedColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatItem(
                        icon: LucideIcons.check,
                        value:
                            learnedWords
                                .where((w) => w.isMastered == true)
                                .length,
                        label: 'Mastered',
                        color: AppColors.masteredColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ShadButton(
                  width: double.infinity,
                  child: const Text('Practice Now'),
                  onPressed: () {
                    showPracticeConfigBottomSheet(context);
                  },
                ),
              ),
              const SizedBox(height: 32),
              _buildWordSection(
                context: context,
                title: 'Learned Words',
                subtitle: '${learnedWords.length} words',
                words: learnedWords,
              ),
              const SizedBox(height: 32),
              _buildWordSection(
                context: context,
                title: 'Words to Learn',
                subtitle: '${notLearnedWords.length} words remaining',
                words: notLearnedWords,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required int value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withAlpha(26),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value.toString(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(label, style: TextStyle(fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWordSection({
    required BuildContext context,
    required String title,
    required String subtitle,
    required List<Word> words,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(fontSize: 13)),
                ],
              ),
              TextButton(
                onPressed: () {
                  context.push(AppRoutes.collectionListWordsUrl('123'));
                },
                child: Row(
                  children: [
                    Text('See all', style: TextStyle(fontSize: 13)),
                    const SizedBox(width: 4),
                    Icon(LucideIcons.chevronRight, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            mainAxisExtent: 210,
          ),
          itemCount: words.length.clamp(0, 10), // Using unlearned words
          itemBuilder: (context, index) {
            return WordItemWidget(wordId: words[index].id);
          },
        ),
      ],
    );
  }
}
