import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_books_api/google_books_api.dart';
import 'package:http/http.dart';
import 'package:kitablog/models/saved_book.dart';

class ApiHelper {

  Future<List<Book>> getBooks(String query, {QueryType queryType = QueryType.subject}) async {
    List<Book> books = [];
    try {
      books = await const GoogleBooksApi().searchBooks(query, queryType: queryType, orderBy: OrderBy.newest, langRestrict: 'en', );
    } on SocketException catch (e) {
      debugPrint(e.toString());
    } on ClientException catch (e) {
      debugPrint(e.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
    return books;
  }

  SavedBook _parseBook(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'];
    return SavedBook(
      bookId: json['id'],
      title: volumeInfo['title'] ?? '',
      subtitle: volumeInfo['subtitle'] ?? '',
      authors: (volumeInfo['authors'] as List<dynamic>?)?.join(', ') ?? '',
      description: volumeInfo['description'] ?? '',
      imageUrl: volumeInfo['imageLinks']?['thumbnail'] ?? '',
      publishedDate: volumeInfo['publishedDate'] ?? '',
      isbn: volumeInfo['industryIdentifiers']?.isNotEmpty == true
          ? volumeInfo['industryIdentifiers'][0]['identifier']
          : '',
      publisher: volumeInfo['publisher'] ?? '',
      pages: volumeInfo['pageCount']?.toString() ?? '',
      categories: (volumeInfo['categories'] as List<dynamic>?)?.join(', ') ?? '',
      price: '', // Handle price if needed
      language: volumeInfo['language'] ?? '',
      rating: '', // Handle rating if needed
      state: '', // Handle state if needed
      timestamp: DateTime.now().toIso8601String(),
    );
  }
}
