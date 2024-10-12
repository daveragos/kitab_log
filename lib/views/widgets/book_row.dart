import 'package:flutter/material.dart';
import 'package:google_books_api/google_books_api.dart';
import 'package:kitablog/views/book_detail.dart';
import 'package:kitablog/views/explore.dart';
import 'package:kitablog/views/widgets/book_column.dart';

class BookRow extends StatefulWidget {
  const BookRow({super.key, required this.query, required this.getBooks});

  final String query;
  final Function(String) getBooks;


  @override
  State<BookRow> createState() => _BookRowState();
}


class _BookRowState extends State<BookRow> {
  @override
  Widget build(BuildContext context) {
    return Column(
                  children: [
                // Horizontally scrollable row of scientific book thumbnails
                 Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 8.0),
                  child: Row(
                    children: [
                      Text(
                        widget.query,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                       InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookList( query: widget.query, getBooks: widget.getBooks),
                            ),
                          );
                        },
                        child: const Text('more',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                        )
                        ),
                      ),
                    ],
                  ),
                ),
                    FutureBuilder<List<Book>>(
                      future: widget.getBooks(widget.query), // Fetch scientific books
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator()); // Show loading
                        } else if (snapshot.hasError) {
                          return const Center(child: Text('Error loading books.'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('No books available.'));
                        }

                        // Display horizontal scrollable list of scientific books
                        return SingleChildScrollView(
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
                        );
                      },
                    ),
                  ],
                );
  }
}