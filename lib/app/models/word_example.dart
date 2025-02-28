class WordExample {
  String id;
  String word;
  String example;
  String audioUrl;

  WordExample({
    required this.id,
    required this.word,
    required this.example,
    required this.audioUrl,
  });

  Map<String, dynamic> toJson() {
    return {"id": id, "word": word, "example": example, "audioUrl": audioUrl};
  }

  factory WordExample.fromJson(Map<String, dynamic> json) {
    return WordExample(
      id: json['id'],
      word: json['word'],
      example: json['example'],
      audioUrl: json['audioUrl'],
    );
  }
}
