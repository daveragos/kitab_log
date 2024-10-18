import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_books_api/google_books_api.dart';
import 'package:kitablog/services/api_helper.dart';
import 'package:kitablog/views/widgets/saved_book_list.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchTerm = '';
  bool isLoading = false; // For showing the loading indicator
  final TextEditingController _controller = TextEditingController();

  final List<String> recommendedCategories = [
    'Science Fiction', 'Technology', 'History', 'Romance', 'Art', 'Business'
  ];

  // Method to search for books from Google Books API
  void _searchBooks(String query, {QueryType queryType = QueryType.intitle}) async {
    setState(() {
      isLoading = true; // Start loading
    });

    final googleBooksAPI = ApiHelper();
    try {
      final results = await googleBooksAPI.getBooks(query, queryType: queryType);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SavedBookList(books: results),
        ),
      );
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to search books: $e')),
      );
    } finally {
      setState(() {
        isLoading = false; // Stop loading after search completes
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'Search for books...',
            border: InputBorder.none,
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear(); // Clear the search input
                      setState(() {
                        searchTerm = ''; // Reset search term
                      });
                    },
                  )
                : null, // Show 'X' icon only if there is input text
          ),
          onChanged: (text) {
            setState(() {
              searchTerm = text; // Update the search term as user types
            });
          },
          onSubmitted: (query) {
            _searchBooks(query, queryType: QueryType.intitle); // Use 'intitle' for general search
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Recommended Categories',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          Wrap(
            spacing: 8,
            children: recommendedCategories.map((category) {
              return ActionChip(
                label: Text(category),
                onPressed: () {
                  _searchBooks(category, queryType: QueryType.subject); // Search by subject for recommended categories
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          isLoading
              ? const Center(child: CircularProgressIndicator()) // Show loading indicator
              : const SizedBox.shrink(), // Hide it when not loading
        ],
      ),
    );
  }
}
