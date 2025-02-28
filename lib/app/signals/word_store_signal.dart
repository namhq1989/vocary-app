import 'package:signals/signals_flutter.dart';
import 'package:vocary/app/models/word.dart';

class WordStoreSignals {
  static final words = signal<Map<String, Word>>({});

  static Word? getWord(String id) {
    return words.value[id];
  }

  static void addWords(List<Word> newWords) {
    final updatedWords = {...words.value};
    for (final word in newWords) {
      updatedWords[word.id] = word;
    }
    words.value = updatedWords;
  }

  static void updateWord(Word updatedWord) {
    if (!words.value.containsKey(updatedWord.id)) return;

    words.value = {...words.value, updatedWord.id: updatedWord};
  }

  static void removeWord(String id) {
    if (!words.value.containsKey(id)) return;

    final updatedWords = {...words.value}..remove(id);
    words.value = updatedWords;
  }

  static void clearAll() {
    words.value = {};
  }
}
