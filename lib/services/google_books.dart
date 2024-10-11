import 'dart:convert';
import 'package:google_books_api/google_books_api.dart';
import 'package:http/http.dart' as http;

class GoogleBooksService {
  final String apiKey = 'AIzaSyDXsWosaT7ZEct9YbuKxcqi6kefl2qvZBI';

  Future<List<Book>> fetchBooks(String query) async {
    final url = 'https://www.googleapis.com/books/v1/volumes?q=$query&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List books = data['items'];
      return books.map((book) => Book.fromJson(book)).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }
}
