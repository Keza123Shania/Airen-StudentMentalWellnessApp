import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/journal_entry.dart';
import '../services/storage_service.dart';

final journalEntriesProvider = StateNotifierProvider<JournalEntriesNotifier, List<JournalEntry>>((ref) {
  return JournalEntriesNotifier();
});

class JournalEntriesNotifier extends StateNotifier<List<JournalEntry>> {
  JournalEntriesNotifier() : super([]) {
    _loadEntries();
  }

  void _loadEntries() {
    final entries = StorageService.instance.getJournalEntries();
    entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    state = entries;
  }

  Future<void> addEntry(JournalEntry entry) async {
    await StorageService.instance.saveJournalEntry(entry);
    state = [entry, ...state];
  }

  Future<void> updateEntry(JournalEntry entry) async {
    await StorageService.instance.saveJournalEntry(entry);
    state = state.map((e) => e.id == entry.id ? entry : e).toList();
  }

  Future<void> deleteEntry(String id) async {
    await StorageService.instance.deleteJournalEntry(id);
    state = state.where((entry) => entry.id != id).toList();
  }

  List<JournalEntry> getRecentEntries({int limit = 5}) {
    return state.take(limit).toList();
  }
}
