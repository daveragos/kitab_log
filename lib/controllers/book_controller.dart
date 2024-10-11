import 'dart:convert';
import 'package:google_books_api/google_books_api.dart';
import 'package:http/http.dart' as http;

class BookController {
  final String apiKey = 'AIzaSyDXsWosaT7ZEct9YbuKxcqi6kefl2qvZBI'; // Replace with your Google Books API key

  BookController();

  // Fetch books using Google Books API
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
    // TODO: Add code here for addBook
  }

  void editBook() {
    // TODO: Add code here for editBook
  }

  void deleteBook() {
    // TODO: Add code here for deleteBook
  }

  void getBook() {
    // TODO: Add code here for getBook
  }

  void addBooks() {
    // TODO: Add code here for addBooks
  }

  void editBooks() {
    // TODO: Add code here for editBooks
  }

  void deleteBooks() {
    // TODO: Add code here for deleteBooks
  }

  void getBooksByCategory() {
    // TODO: Add code here for getBooksByCategory
  }

  void getBooksByAuthor() {
    // TODO: Add code here for getBooksByAuthor
  }

  void getBooksByPublisher() {
    // TODO: Add code here for getBooksByPublisher
  }

  void getBooksByPrice() {
    // TODO: Add code here for getBooksByPrice
  }

  void getBooksByRating() {
    // TODO: Add code here for getBooksByRating
  }

  void getBooksByLanguage() {
    // TODO: Add code here for getBooksByLanguage
  }

  void getBooksByIsbn() {
    // TODO: Add code here for getBooksByIsbn
  }

  void getBooksByPages() {
    // TODO: Add code here for getBooksByPages
  }

  void getBooksByCategories() {
    // TODO: Add code here for getBooksByCategories
  }

  void getBooksByDescription() {
    // TODO: Add code here for getBooksByDescription
  }

  void getBooksByTitle() {
    // TODO: Add code here for getBooksByTitle
  }

  void getBooksById() {
    // TODO: Add code here for getBooksById
  }
}
