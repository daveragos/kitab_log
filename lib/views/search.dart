import 'package:flutter/material.dart';
import 'package:google_books_api/google_books_api.dart';
import 'package:kitablog/services/api_helper.dart';
import 'package:kitablog/views/widgets/book_column.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchTerm = '';
  bool isLoading = false;
  final TextEditingController _controller = TextEditingController();

  final List<String> recommendedCategories = [
    'Science Fiction', 'Technology', 'History', 'Romance', 'Art', 'Business'
  ];


  void _searchBooks(String query, {QueryType queryType = QueryType.intitle}) async {
    setState(() {
      isLoading = true;
    });

    final googleBooksAPI = ApiHelper();
    try {
      final results = await googleBooksAPI.getBooks(query, queryType: queryType);


      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookList(query: query, books: results),
        ),
      );
    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to search books: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
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
                      _controller.clear();
                      setState(() {
                        searchTerm = '';
                      });
                    },
                  )
                : null,
          ),
          onChanged: (text) {
            setState(() {
              searchTerm = text;
            });
          },
          onSubmitted: (query) {
            _searchBooks(query, queryType: QueryType.intitle);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
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
                    _searchBooks(category, queryType: QueryType.subject);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
