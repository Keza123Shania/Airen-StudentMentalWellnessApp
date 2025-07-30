import 'package:uuid/uuid.dart';

class ChatRoom {
  final String id;
  final String name;
  final String description;
  final DateTime createdAt;
  final int memberCount;

  ChatRoom({
    String? id,
    required this.name,
    required this.description,
    DateTime? createdAt,
    this.memberCount = 1,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'memberCount': memberCount,
    };
  }

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      memberCount: json['memberCount'] ?? 1,
    );
  }
}

class ChatMessage {
  final String id;
  final String content;
  final String senderName;
  final DateTime timestamp;
  final bool isMe;

  ChatMessage({
    String? id,
    required this.content,
    required this.senderName,
    DateTime? timestamp,
    this.isMe = false,
  })  : id = id ?? const Uuid().v4(),
        timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'senderName': senderName,
      'timestamp': timestamp.toIso8601String(),
      'isMe': isMe,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      content: json['content'],
      senderName: json['senderName'],
      timestamp: DateTime.parse(json['timestamp']),
      isMe: json['isMe'] ?? false,
    );
  }
}
