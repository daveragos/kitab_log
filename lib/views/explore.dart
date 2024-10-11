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
  Future<List<Book>> getBooks(String query) async {
    List<Book> books = [];
    try {
      books = await const GoogleBooksApi().searchBooks(query, queryType: QueryType.subject);
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
              children: [
                BookRow(query: 'Technology', getBooks: getBooks),
                const SizedBox(height: 16),
                BookRow(query: 'History', getBooks: getBooks),
                const SizedBox(height: 16),
                BookRow(query: 'Biography', getBooks: getBooks),
                const SizedBox(height: 16),
                BookRow(query: 'Philosophy', getBooks: getBooks),
                const SizedBox(height: 16),
                BookRow(query: 'Religion', getBooks: getBooks),
                const SizedBox(height: 16),
                BookRow(query: 'Mathematics', getBooks: getBooks),
                const SizedBox(height: 16),
                BookRow(query: 'Chemistry', getBooks: getBooks),
                const SizedBox(height: 16),
                BookRow(query: 'Physics', getBooks: getBooks),
               const SizedBox(height: 16),
               BookRow(query: 'Economics', getBooks: getBooks),
                const SizedBox(height: 16),
                BookRow(query: 'Politics', getBooks: getBooks),
                const SizedBox(height: 16),
                BookRow(query: 'Law', getBooks: getBooks),
                const SizedBox(height: 16),


              ],
            ),
          ),
        ),
      ),
    );
  }
}



/*
VERTICAL
Column(
                  children: [
                // Vertical list of all books
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'All Books',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                    FutureBuilder<List<Book>>(
                      future: getBooks('Science and fiction, computer and technology'), // Fetch all books
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator()); // Show loading
                        } else if (snapshot.hasError) {
                          return const Center(child: Text('Error loading all books.'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('No books available.'));
                        }

                        // Display vertical list of all books
                        return ListView.builder(
                          shrinkWrap: true, // Important to make ListView scroll within SingleChildScrollView
                          physics: const NeverScrollableScrollPhysics(), // Prevent internal scroll
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final book = snapshot.data![index];
                            return ListTile(
                              leading: Container(
                                width: 100,  // Larger width for the book image
                                height: 150, // Larger height for the book image
                                margin: const EdgeInsets.only(right: 16.0),
                                child: Image.network(
                                  book.volumeInfo.imageLinks?['thumbnail'].toString() ??
                                      'https://lh3.googleusercontent.com/proxy/4z1e5tJL9nhsfFc6X3jsElJ_xOvo1uuiiCb5J_qdv7ZjOw5J4bzP1E3FdFbYBlvQpcIs7kgXC2xcKovRP-L2cGEop_IXbL3P1SauzTkY',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(book.volumeInfo.title),
                              subtitle: Text(book.volumeInfo.subtitle ?? ''), // Added null check
                              onTap: () {
                                // Navigate to the BookDetail screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookDetail(book: book),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
*/