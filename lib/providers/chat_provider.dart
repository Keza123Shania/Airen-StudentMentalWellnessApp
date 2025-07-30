import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat_room.dart';
import '../services/storage_service.dart';

final chatRoomsProvider = StateNotifierProvider<ChatRoomsNotifier, List<ChatRoom>>((ref) {
  return ChatRoomsNotifier();
});

final chatMessagesProvider = StateNotifierProvider.family<ChatMessagesNotifier, List<ChatMessage>, String>((ref, roomId) {
  return ChatMessagesNotifier(roomId);
});

class ChatRoomsNotifier extends StateNotifier<List<ChatRoom>> {
  ChatRoomsNotifier() : super([]) {
    _loadRooms();
  }

  void _loadRooms() {
    final rooms = StorageService.instance.getChatRooms();
    state = rooms;
  }

  Future<void> addRoom(ChatRoom room) async {
    await StorageService.instance.saveChatRoom(room);
    state = [...state, room];
  }

  Future<void> deleteRoom(String id) async {
    await StorageService.instance.deleteChatRoom(id);
    state = state.where((room) => room.id != id).toList();
  }
}

class ChatMessagesNotifier extends StateNotifier<List<ChatMessage>> {
  final String roomId;

  ChatMessagesNotifier(this.roomId) : super([]) {
    _loadMessages();
  }

  void _loadMessages() {
    // In a real app, this would load from a database or API
    // For now, we'll start with some sample messages
    state = [
      ChatMessage(
        content: 'Welcome to the chat room! Feel free to share your thoughts.',
        senderName: 'Moderator',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
    ];
  }

  void addMessage(ChatMessage message) {
    state = [...state, message];
  }

  void addMyMessage(String content) {
    final message = ChatMessage(
      content: content,
      senderName: 'You',
      isMe: true,
    );
    addMessage(message);
    
    // Simulate a response after a delay
    Future.delayed(const Duration(seconds: 2), () {
      final responses = [
        'Thank you for sharing that.',
        'I understand how you feel.',
        'You\'re not alone in this.',
        'That sounds really challenging.',
        'Take care of yourself.',
      ];
      final response = ChatMessage(
        content: responses[DateTime.now().millisecond % responses.length],
        senderName: 'Anonymous User',
      );
      addMessage(response);
    });
  }
}
