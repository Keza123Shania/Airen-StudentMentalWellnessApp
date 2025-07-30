import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _quotesApiUrl = 'https://api.quotable.io/random';

  static Future<Map<String, String>?> fetchQuoteOfTheDay() async {
    try {
      final response = await http.get(
        Uri.parse('$_quotesApiUrl?tags=motivational,inspirational'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'quote': data['content'] as String,
          'author': data['author'] as String,
        };
      }
    } catch (e) {
      print('Error fetching quote: $e');
    }
    
    // Fallback quote
    return {
      'quote': 'The only way to do great work is to love what you do.',
      'author': 'Steve Jobs',
    };
  }
}
