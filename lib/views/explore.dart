import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_books_api/google_books_api.dart';
import 'package:http/http.dart';
import 'package:kitablog/views/widgets/book_row.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart'; // Import the package
import 'book_detail.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
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

  Future<void> _refreshScientificBooks() async {
    setState(() {
      // Trigger rebuild to refresh the books
    });
  }

  Future<void> _refreshAllBooks() async {
    setState(() {
      // Trigger rebuild to refresh the books
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LiquidPullToRefresh(
        onRefresh: () async {
          await Future.wait([
            _refreshScientificBooks(),
            _refreshAllBooks(),
          ]);
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                categories
                .map((category) => BookRow(query: category, getBooks: getBooks)).toList()
                ..shuffle()

            ),
          ),
        ),
      ),
    );
  }
}
