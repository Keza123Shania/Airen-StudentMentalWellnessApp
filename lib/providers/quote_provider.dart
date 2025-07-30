import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';

final quoteProvider = FutureProvider<Map<String, String>?>((ref) async {
  return await ApiService.fetchQuoteOfTheDay();
});
