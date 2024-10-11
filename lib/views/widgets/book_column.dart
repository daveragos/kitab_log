import 'package:flutter/material.dart';
import 'package:google_books_api/google_books_api.dart';
import 'package:kitablog/views/book_detail.dart';

class BookList extends StatefulWidget {
  const BookList({super.key, required this.query, required this.getBooks});

  final String query;
  final Function(String) getBooks;

  @override
  State<BookList> createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
                        children: [
                          Container(
                // padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.symmetric(
                    horizontal: BorderSide(
                      width: 2,
                      color: Colors.black,
                    ),
                  )
                ),
                child:
                          Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            width: 2,
                            color: Colors.black,
                          ),
                        )
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),

                    Expanded(
                      child: Center(
                        child: Text(
                          widget.query,
                          style:  TextStyle(
                            fontSize: 24,
                            fontFamily: 'RobotoSlab',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            width: 2,
                            color: Colors.black,
                          ),
                        )
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.notifications_none),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Not implemented yet.'),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),),
                      // Vertical list of all books

                          FutureBuilder<List<Book>>(
                            future: widget.getBooks(widget.query), // Fetch all books
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator()); // Show loading
                              } else if (snapshot.hasError) {
                                return const Center(child: Text('Error loading books.'));
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
        ),
      ),
    );
  }
}