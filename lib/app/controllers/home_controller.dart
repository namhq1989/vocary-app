import 'package:signals/signals_flutter.dart';
import 'package:vocary/app/models/word.dart';
import 'package:vocary/app/models/word_example.dart';
import 'package:vocary/app/signals/word_store_signal.dart';

final List<Word> _dummyWords = [
  Word(
    id: '1',
    word: 'serendipity',
    ipa: '/ˌsɛrənˈdɪpɪti/',
    definitions: [
      'The occurrence of events by chance in a happy or beneficial way',
      'The fact of finding interesting or valuable things by chance',
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

class HomeController {
  static final randomWords = signal<List<Word>>([]);
  static final isFetchingRandomWords = signal<bool>(false);

  static Future<void> fetchRandomWords() async {
    isFetchingRandomWords.value = true;
    await Future.delayed(const Duration(seconds: 2));
    randomWords.value = _dummyWords;
    WordStoreSignals.addWords(_dummyWords);
    isFetchingRandomWords.value = false;
  }
}
