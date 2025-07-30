import 'package:uuid/uuid.dart';

class JournalEntry {
  final String id;
  final String title;
  final String content;
  final MoodType mood;
  final DateTime createdAt;
  final DateTime updatedAt;

  JournalEntry({
    String? id,
    required this.title,
    required this.content,
    required this.mood,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  JournalEntry copyWith({
    String? title,
    String? content,
    MoodType? mood,
    DateTime? updatedAt,
  }) {
    return JournalEntry(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      mood: mood ?? this.mood,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'mood': mood.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      mood: MoodType.values.firstWhere((e) => e.name == json['mood']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

enum MoodType {
  veryHappy('😄', 'Very Happy', 5),
  happy('😊', 'Happy', 4),
  neutral('😐', 'Neutral', 3),
  sad('😢', 'Sad', 2),
  verySad('😭', 'Very Sad', 1);

  const MoodType(this.emoji, this.label, this.value);

  final String emoji;
  final String label;
  final int value;
}
