import 'package:flutter/material.dart';
import 'package:vocary/app/models/word.dart';
import 'package:vocary/resources/widgets/word_item_widget.dart';

final List<Word> wordsList = [
  Word(
    word: 'Hello',
    ipa: '/həˈloʊ/',
    meaning: 'A common greeting used to start a conversation.',
    pos: ['interjection', 'noun'],
    mastered: true,
    level: 'Beginner',
  ),
  Word(
    word: 'World',
    ipa: '/wɜrld/',
    meaning: 'The earth, including all its countries and peoples.',
    pos: ['noun'],
    mastered: false,
    streak: 3,
    required: 5,
    level: 'Beginner',
  ),
  Word(
    word: 'Flutter',
    ipa: '/ˈflʌtər/',
    meaning: 'A framework by Google for building applications.',
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
    meaning: 'Relating to portable devices like smartphones.',
    pos: ['adjective', 'noun'],
    mastered: true,
    level: 'Intermediate',
  ),
  Word(
    word: 'App',
    ipa: '/æp/',
    meaning: 'A software program for a specific function.',
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
    streak: 0,
    required: 5,
    level: 'Advanced',
  ),
  Word(
    word: 'Design',
    ipa: '/dɪˈzaɪn/',
    meaning: 'The process of planning and structuring aesthetics.',
    pos: ['noun'],
    mastered: true,
    level: 'Intermediate',
  ),
  Word(
    word: 'Test',
    ipa: '/tɛst/',
    meaning: 'A process to assess quality and reliability.',
    pos: ['verb'],
    mastered: false,
    streak: 2,
    required: 5,
    level: 'Advanced',
  ),
];

class CollectionListWordsScreen extends StatelessWidget {
  final String collectionId;

  const CollectionListWordsScreen({super.key, required this.collectionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Collection List Words")),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  mainAxisExtent: 210,
                ),
                itemCount: wordsList.length.clamp(0, 10),
                itemBuilder: (context, index) {
                  return WordItemWidget(word: wordsList[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
