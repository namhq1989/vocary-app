class WordExample {
  String id;
  String word;
  String sentence;
  String audioUrl;

  WordExample({
    required this.id,
    required this.word,
    required this.sentence,
    required this.audioUrl,
  });

  Map<String, dynamic> toJson() {
    return {"id": id, "word": word, "sentence": sentence, "audioUrl": audioUrl};
  }

  factory WordExample.fromJson(Map<String, dynamic> json) {
    return WordExample(
      id: json['id'],
      word: json['word'],
      sentence: json['sentence'],
      audioUrl: json['audioUrl'],
    );
  }
}
