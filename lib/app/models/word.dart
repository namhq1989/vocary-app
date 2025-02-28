import 'package:vocary/app/models/word_example.dart';

class Word {
  final String id;
  final String word;
  final List<String> definitions;
  final List<String> pos;
  final String ipa;
  final String audioUrl;
  final String level;
  final List<String> synonyms;
  final List<String> antonyms;
  final List<WordExample> examples;
  final bool isFavorite;
  final bool isMastered;
  final int currentStreak;
  final int masteryThreshold;

  Word({
    required this.id,
    required this.word,
    required this.definitions,
    required this.pos,
    required this.ipa,
    required this.audioUrl,
    required this.level,
    required this.synonyms,
    required this.antonyms,
    this.examples = const [],
    required this.isFavorite,
    required this.isMastered,
    required this.currentStreak,
    required this.masteryThreshold,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "word": word,
      "definitions": definitions,
      "pos": pos,
      "ipa": ipa,
      "audioUrl": audioUrl,
      "level": level,
      "synonyms": synonyms,
      "antonyms": antonyms,
      "examples": examples.map((e) => e.toJson()).toList(),
      "isFavorite": isFavorite,
      "isMastered": isMastered,
      "currentStreak": currentStreak,
      "masteryThreshold": masteryThreshold,
    };
  }

  Word copyWith({
    String? id,
    String? word,
    List<String>? definitions,
    List<String>? pos,
    String? ipa,
    String? audioUrl,
    String? level,
    List<String>? synonyms,
    List<String>? antonyms,
    List<WordExample>? examples,
    bool? isFavorite,
    bool? isMastered,
    int? currentStreak,
    int? masteryThreshold,
  }) {
    return Word(
      id: id ?? this.id,
      word: word ?? this.word,
      definitions: definitions ?? this.definitions,
      pos: pos ?? this.pos,
      ipa: ipa ?? this.ipa,
      audioUrl: audioUrl ?? this.audioUrl,
      level: level ?? this.level,
      synonyms: synonyms ?? this.synonyms,
      antonyms: antonyms ?? this.antonyms,
      examples: examples ?? this.examples,
      isFavorite: isFavorite ?? this.isFavorite,
      isMastered: isMastered ?? this.isMastered,
      currentStreak: currentStreak ?? this.currentStreak,
      masteryThreshold: masteryThreshold ?? this.masteryThreshold,
    );
  }

  // Increase the streak after correct exercise completion
  Word increaseStreak() {
    int updatedStreak = (currentStreak + 1).clamp(0, masteryThreshold);
    return copyWith(
      currentStreak: updatedStreak,
      isMastered: updatedStreak >= masteryThreshold,
    );
  }

  // Decrease the streak after incorrect exercise completion
  Word decreaseStreak() {
    int updatedStreak = (currentStreak - 1).clamp(0, masteryThreshold);
    return copyWith(
      currentStreak: updatedStreak,
      isMastered: updatedStreak >= masteryThreshold,
    );
  }

  // Calculate mastery impact based on exercise results
  Word updateMasteryFromExercise(bool allExercisesCorrect, double accuracy) {
    if (allExercisesCorrect) {
      // All exercises correct - increase mastery
      return increaseStreak();
    } else if (accuracy >= 70) {
      // More than 70% correct - maintain streak
      return this;
    } else {
      // Less than 70% correct - decrease mastery
      return decreaseStreak();
    }
  }

  // Toggle favorite status
  Word toggleFavorite() {
    return copyWith(isFavorite: !isFavorite);
  }

  // Factory method to create from JSON
  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      id: json['id'],
      word: json['word'],
      definitions: List<String>.from(json['definitions'] ?? []),
      pos: List<String>.from(json['pos'] ?? []),
      ipa: json['ipa'] ?? '',
      audioUrl: json['audioUrl'] ?? '',
      level: json['level'] ?? '',
      synonyms: List<String>.from(json['synonyms'] ?? []),
      antonyms: List<String>.from(json['antonyms'] ?? []),
      examples:
          json['examples'] != null
              ? (json['examples'] as List)
                  .map((e) => WordExample.fromJson(e))
                  .toList()
              : [],
      isFavorite: json['isFavorite'] ?? false,
      isMastered: json['isMastered'] ?? false,
      currentStreak: json['currentStreak'] ?? 0,
      masteryThreshold: json['masteryThreshold'] ?? 5,
    );
  }
}
