import 'dart:convert';
import 'package:google_books_api/google_books_api.dart';
import 'package:http/http.dart' as http;

class BookController {
  final String apiKey = 'AIzaSyDXsWosaT7ZEct9YbuKxcqi6kefl2qvZBI';

  BookController();


  Future<List<Book>> getBooks(String query) async {
    List<Book> books = [];
    final response = await http.get(
      Uri.parse('https://www.googleapis.com/books/v1/volumes?q=$query&key=$apiKey')
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      for (var bookData in body['items']) {
        final book = Book.fromJson(bookData);
        books.add(book);
      }
    } else {
      throw Exception('Failed to load books');
    }

    return books;
  }

  void addBook() {

  }

  void editBook() {

  }

  void deleteBook() {

  }

  void getBook() {

  }

  void addBooks() {

  }

  void editBooks() {

  }

  void deleteBooks() {

  }

  void getBooksByCategory() {

  }

  void getBooksByAuthor() {

  }

  void getBooksByPublisher() {

  }

  void getBooksByPrice() {

  }

  void getBooksByRating() {

  }

  void getBooksByLanguage() {

  }

  void getBooksByIsbn() {

  }

  void getBooksByPages() {

  }

  void getBooksByCategories() {

  }

  void getBooksByDescription() {

  }

  void getBooksByTitle() {

  }

  void getBooksById() {

  }
}
