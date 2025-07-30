import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/journal_entry.dart';
import '../models/chat_room.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  static StorageService get instance => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Theme Management
  Future<void> setThemeMode(String themeMode) async {
    await _prefs?.setString('theme_mode', themeMode);
  }

  String getThemeMode() {
    return _prefs?.getString('theme_mode') ?? 'system';
  }

  // Journal Entries CRUD
  Future<void> saveJournalEntry(JournalEntry entry) async {
    final entries = getJournalEntries();
    final existingIndex = entries.indexWhere((e) => e.id == entry.id);
    
    if (existingIndex != -1) {
      entries[existingIndex] = entry;
    } else {
      entries.add(entry);
    }
    
    final jsonList = entries.map((e) => e.toJson()).toList();
    await _prefs?.setString('journal_entries', jsonEncode(jsonList));
  }

  List<JournalEntry> getJournalEntries() {
    final jsonString = _prefs?.getString('journal_entries');
    if (jsonString == null) return [];
    
    final jsonList = jsonDecode(jsonString) as List;
    return jsonList.map((json) => JournalEntry.fromJson(json)).toList();
  }

  Future<void> deleteJournalEntry(String id) async {
    final entries = getJournalEntries();
    entries.removeWhere((entry) => entry.id == id);
    
    final jsonList = entries.map((e) => e.toJson()).toList();
    await _prefs?.setString('journal_entries', jsonEncode(jsonList));
  }

  // Chat Rooms CRUD
  Future<void> saveChatRoom(ChatRoom room) async {
    final rooms = getChatRooms();
    final existingIndex = rooms.indexWhere((r) => r.id == room.id);
    
    if (existingIndex != -1) {
      rooms[existingIndex] = room;
    } else {
      rooms.add(room);
    }
    
    final jsonList = rooms.map((r) => r.toJson()).toList();
    await _prefs?.setString('chat_rooms', jsonEncode(jsonList));
  }

  List<ChatRoom> getChatRooms() {
    final jsonString = _prefs?.getString('chat_rooms');
    if (jsonString == null) return _getDefaultChatRooms();
    
    final jsonList = jsonDecode(jsonString) as List;
    return jsonList.map((json) => ChatRoom.fromJson(json)).toList();
  }

  Future<void> deleteChatRoom(String id) async {
    final rooms = getChatRooms();
    rooms.removeWhere((room) => room.id == id);
    
    final jsonList = rooms.map((r) => r.toJson()).toList();
    await _prefs?.setString('chat_rooms', jsonEncode(jsonList));
  }

  List<ChatRoom> _getDefaultChatRooms() {
    return [
      ChatRoom(
        name: 'General Support',
        description: 'A safe space for general mental health discussions',
        memberCount: 24,
      ),
      ChatRoom(
        name: 'Study Stress',
        description: 'Share tips and support for academic pressure',
        memberCount: 18,
      ),
      ChatRoom(
        name: 'Anxiety Support',
        description: 'Connect with others dealing with anxiety',
        memberCount: 31,
      ),
    ];
  }

  // Clear all data
  Future<void> clearAllData() async {
    await _prefs?.remove('journal_entries');
    await _prefs?.remove('chat_rooms');
  }

  // App version
  String getAppVersion() {
    return '1.0.0';
  }
}
