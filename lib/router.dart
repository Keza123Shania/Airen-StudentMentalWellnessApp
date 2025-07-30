import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'screens/splash_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/entry_screen.dart';
import 'screens/history_screen.dart';
import 'screens/chat_lobby_screen.dart';
import 'screens/chat_room_screen.dart';
import 'screens/meditation_screen.dart';
import 'screens/settings_screen.dart';
import 'models/journal_entry.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/entry',
        name: 'entry',
        builder: (context, state) {
          final entry = state.extra as JournalEntry?;
          return EntryScreen(entry: entry);
        },
      ),
      GoRoute(
        path: '/history',
        name: 'history',
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: '/chat-lobby',
        name: 'chat-lobby',
        builder: (context, state) => const ChatLobbyScreen(),
      ),
      GoRoute(
        path: '/chat-room/:roomId',
        name: 'chat-room',
        builder: (context, state) {
          final roomId = state.pathParameters['roomId']!;
          final roomName = state.uri.queryParameters['name'] ?? 'Chat Room';
          return ChatRoomScreen(roomId: roomId, roomName: roomName);
        },
      ),
      GoRoute(
        path: '/meditation',
        name: 'meditation',
        builder: (context, state) => const MeditationScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});
