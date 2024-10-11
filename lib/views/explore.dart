import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_books_api/google_books_api.dart';
import 'package:http/http.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart'; // Import the package
import 'book_detail.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  List<Book> _books = [];

  Future<List<Book>> getBooks() async {
    try {
      _books = await const GoogleBooksApi().searchBooks('Computer Science',queryType: QueryType.subject);
    } on SocketException catch (e) {
      debugPrint(e.toString());
    } on ClientException catch (e) {
      debugPrint(e.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
    return _books;
  }

  Future<void> _refreshBooks() async {
    setState(() {
      _books = []; // Clear the existing list before fetching new data
    });
    await getBooks(); // Fetch the books again
  }

  @override
  void initState() {
    super.initState();
    // Fetch the books initially
    getBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LiquidPullToRefresh(
        onRefresh: _refreshBooks, // Refresh function
        child: FutureBuilder<List<Book>>(
          future: getBooks(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator()); // Show loading
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading books. Pull to refresh.'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No books available. Pull to refresh.'));
            }

            // If data is available, display the scrollable content
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Horizontally scrollable row of book thumbnails
                    Row(
                      children: [
                        Text(
                          'Scientific Books',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        Text('more'),
                      ],
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: snapshot.data!.map((book) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                // Navigate to the BookDetail screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookDetail(book: book),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 2,
                                      ),
                                    ),
                                    child: Image.network(
                                      book.volumeInfo.imageLinks?['thumbnail'].toString() ??
                                          'https://lh3.googleusercontent.com/proxy/4z1e5tJL9nhsfFc6X3jsElJ_xOvo1uuiiCb5J_qdv7ZjOw5J4bzP1E3FdFbYBlvQpcIs7kgXC2xcKovRP-L2cGEop_IXbL3P1SauzTkY',
                                      width: 150,
                                      height: 220,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  // Wrap Text widgets in a SizedBox and use the maxWidth property
                                  const SizedBox(height: 4), // Space between image and text
                                  SizedBox(
                                    width: 150, // Match the width of the image
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          book.volumeInfo.title,
                                          overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
                                          maxLines: 2, // Allow for two lines for the title
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          book.volumeInfo.authors.join(', '),
                                          overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
                                          maxLines: 1, // Allow for one line for the authors
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Vertical list of books
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'All Books',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListView.builder(
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
                              snapshot.data![index].volumeInfo.imageLinks?['thumbnail'].toString() ??
                                  'https://lh3.googleusercontent.com/proxy/4z1e5tJL9nhsfFc6X3jsElJ_xOvo1uuiiCb5J_qdv7ZjOw5J4bzP1E3FdFbYBlvQpcIs7kgXC2xcKovRP-L2cGEop_IXbL3P1SauzTkY',
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(book.volumeInfo.title),
                          subtitle: Text(book.volumeInfo.subtitle),
                          onTap: () {
                            // Navigate to the BookDetail screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookDetail(book: snapshot.data![index]),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
