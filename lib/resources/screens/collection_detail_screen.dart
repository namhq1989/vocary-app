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
    word: 'Hello',
    ipa: '/həˈloʊ/',
    meaning: 'A common greeting used to initiate a conversation.',
    pos: ['interjection', 'noun'],
    mastered: true,
    level: 'Beginner',
  ),
  Word(
    word: 'World',
    ipa: '/wɜrld/',
    meaning: 'The earth, together with all of its countries and peoples.',
    pos: ['noun'],
    mastered: false,
    streak: 3,
    required: 5,
    level: 'Beginner',
  ),
  Word(
    word: 'Flutter',
    ipa: '/ˈflʌtər/',
    meaning: 'A framework by Google for building mobile and web apps.',
    pos: ['noun', 'verb'],
    mastered: true,
    level: 'Advanced',
  ),
  Word(
    word: 'Dart',
    ipa: '/dɑrt/',
    meaning: 'A programming language optimized for fast apps.',
    pos: ['noun'],
    mastered: false,
    streak: 2,
    required: 5,
    level: 'Advanced',
  ),
  Word(
    word: 'Mobile',
    ipa: '/ˈmoʊbəl/',
    meaning: 'Capable of being moved easily or relating to smartphones.',
    pos: ['adjective', 'noun'],
    mastered: true,
    level: 'Intermediate',
  ),
  Word(
    word: 'App',
    ipa: '/æp/',
    meaning: 'A software program designed to fulfill a specific function.',
    pos: ['noun'],
    mastered: false,
    streak: 4,
    required: 5,
    level: 'Beginner',
  ),
  Word(
    word: 'Code',
    ipa: '/koʊd/',
    meaning: 'Instructions written in a programming language.',
    pos: ['noun'],
    mastered: true,
    level: 'Intermediate',
  ),
  Word(
    word: 'Build',
    ipa: '/bɪld/',
    meaning: 'To compile and prepare code for execution.',
    pos: ['verb'],
    mastered: false,
    streak: 4,
    required: 5,
    level: 'Advanced',
  ),
  Word(
    word: 'Design',
    ipa: '/dɪˈzaɪn/',
    meaning: 'The process of creating a plan for aesthetics and function.',
    pos: ['noun'],
    mastered: true,
    level: 'Intermediate',
  ),
  Word(
    word: 'Test',
    ipa: '/tɛst/',
    meaning: 'A procedure to evaluate performance or reliability.',
    pos: ['verb'],
    mastered: false,
    streak: 2,
    required: 5,
    level: 'Advanced',
  ),
];

final List<Word> notLearnedWords = [
  Word(
    word: 'Algorithm',
    ipa: '/ˈælɡəˌrɪðəm/',
    meaning: 'A step-by-step process for solving a problem.',
    pos: ['noun'],
    mastered: false,
    streak: 0,
    required: 5,
    level: 'Advanced',
  ),
  Word(
    word: 'Syntax',
    ipa: '/ˈsɪnˌtæks/',
    meaning: 'The rules that define the structure of a language.',
    pos: ['noun'],
    mastered: false,
    streak: 0,
    required: 5,
    level: 'Intermediate',
  ),
  Word(
    word: 'Compile',
    ipa: '/kəmˈpaɪl/',
    meaning: 'To convert human-readable code into machine code.',
    pos: ['verb'],
    mastered: false,
    streak: 0,
    required: 5,
    level: 'Advanced',
  ),
  Word(
    word: 'Debug',
    ipa: '/ˈdiˌbʌɡ/',
    meaning: 'To identify and remove errors from software.',
    pos: ['verb'],
    mastered: false,
    streak: 0,
    required: 5,
    level: 'Intermediate',
  ),
  Word(
    word: 'Framework',
    ipa: '/ˈfreɪmˌwɜrk/',
    meaning: 'A collection of code libraries for software development.',
    pos: ['noun'],
    mastered: false,
    streak: 0,
    required: 5,
    level: 'Advanced',
  ),
  Word(
    word: 'Binary',
    ipa: '/ˈbaɪˌnɛri/',
    meaning: 'A numerical system using only 0s and 1s.',
    pos: ['noun', 'adjective'],
    mastered: false,
    streak: 0,
    required: 5,
    level: 'Advanced',
  ),
  Word(
    word: 'Latency',
    ipa: '/ˈleɪtnsi/',
    meaning: 'The delay before a data transfer begins.',
    pos: ['noun'],
    mastered: false,
    streak: 0,
    required: 5,
    level: 'Intermediate',
  ),
  Word(
    word: 'Encryption',
    ipa: '/ɪnˈkrɪpʃən/',
    meaning: 'The process of encoding data for security.',
    pos: ['noun'],
    mastered: false,
    streak: 0,
    required: 5,
    level: 'Advanced',
  ),
  Word(
    word: 'Cache',
    ipa: '/kæʃ/',
    meaning: 'A storage layer for quick data access.',
    pos: ['noun', 'verb'],
    mastered: false,
    streak: 0,
    required: 5,
    level: 'Intermediate',
  ),
  Word(
    word: 'Query',
    ipa: '/ˈkwɪri/',
    meaning: 'A request for information from a database.',
    pos: ['noun', 'verb'],
    mastered: false,
    streak: 0,
    required: 5,
    level: 'Beginner',
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
                                .where((w) => w.mastered == true)
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
            return WordItemWidget(word: words[index]);
          },
        ),
      ],
    );
  }
}
