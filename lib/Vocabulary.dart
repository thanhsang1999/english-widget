class Vocabulary {
  final int? id;
  final String word;
  final String meaning;

  Vocabulary({this.id, required this.word, required this.meaning});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
      'meaning': meaning,
    };
  }

  factory Vocabulary.fromMap(Map<String, dynamic> map) {
    return Vocabulary(
      id: map['id'],
      word: map['word'],
      meaning: map['meaning'],
    );
  }
}
