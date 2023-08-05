import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_notion_api/failure_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_notion_api/item_model.dart';

class HomeworkRepository {
  static const String _baseUrl = 'https://api.notion.com/v1/';

  final http.Client _client;

  // If given a client, them set the input to the client, else make a new client
  HomeworkRepository({http.Client? client}) : _client = client ?? http.Client();

  // Close the client after finishing the work
  void dispose() {
    _client.close();
  }

  Future<List<Item>> getItems() async {
    try {
      // Try to get data from URL
      final url =
          '${_baseUrl}databases/${dotenv.env['NOTION_DATABASE_ID']}/query';
      final response = await _client.post(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader:
              'Bearer ${dotenv.env['NOTION_API_KEY']}',
          'Notion-Version': '2021-05-13',
        },
      );

      // If got data successfully, map it to the Item class
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        // Sort data in descending order to date
        return (data['results'] as List).map((e) => Item.fromMap(e)).toList()
          ..sort((a, b) => b.deadline.compareTo(a.deadline));
      } else {
        throw const Failure(message: 'Something went wrong!');
      }
    } catch (_) {
      throw const Failure(message: 'Something went wrong!');
    }
  }
}
