import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_books_api/google_books_api.dart';
import 'package:http/http.dart';
import 'package:kitablog/views/widgets/book_row.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart'; // Import the package

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  Future<List<Book>> getBooks(String query,
      {QueryType queryType = QueryType.subject}) async {
    List<Book> books = [];
    try {
      books = await const GoogleBooksApi().searchBooks(query,
          queryType: queryType, orderBy: OrderBy.newest, langRestrict: 'en');
    } on SocketException catch (e) {
      debugPrint(e.toString());
    } on ClientException catch (e) {
      debugPrint(e.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
    return books;
  }

  Future<void> _refreshBooks() async {
    if (mounted) {
      setState(() {
        // Trigger rebuild to refresh the books
      });
    }
  }

  List<String> categories = [
    'Fiction',
    'Biography',
    'History',
    'Philosophy',
    'Religion',
    'Mathematics',
    'Chemistry',
    'Physics',
    'Economics',
    'Politics',
    'Law',
    'Science',
    'Technology',
    'Art',
    'Poetry',
    'Music',
    'Romance',
    'Crime',
    'Business',
    'Finance',
    'Health',
    'Sports',
    'Programming',
  ];

  Map<String, List<Book>> bookCache = {};

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    for (String category in categories) {
      List<Book> books = await getBooks(category);
      if (mounted) {
        setState(() {
          bookCache[category] = books;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LiquidPullToRefresh(
        onRefresh: _refreshBooks,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: bookCache.entries.map((entry) {
                return BookRow(query: entry.key, books: entry.value);
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
