import 'package:flutter/material.dart';
import 'package:google_books_api/google_books_api.dart';
import 'package:kitablog/views/book_detail.dart';
import 'package:kitablog/services/db_helper.dart';
import 'package:kitablog/views/search.dart';

class BookList extends StatefulWidget {
  const BookList({super.key, required this.query, required this.books});

  final String query;
  final List<Book> books;

  @override
  State<BookList> createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  Map<String, String?> bookStates = {}; // Store the state of each book
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkBooksInDB(); // Check all books in DB on initialization
  }

  // Check if the books exist in the database and get their states
  Future<void> _checkBooksInDB() async {
    final db = DBHelper();
    final readings = await db.getReadings();

    setState(() {
      for (var book in widget.books) {
        final foundBook = readings.firstWhere(
          (reading) => reading['bookId'] == book.id,
          orElse: () => {},
        );
        if (foundBook.isNotEmpty) {
          bookStates[book.id] = foundBook['state']; // Set the book's state
        } else {
          bookStates[book.id] = null; // Not added to shelf
        }
      }
      isLoading = false; // Stop loading
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  border: Border.symmetric(
                    horizontal: BorderSide(
                      width: 2,
                      color: Colors.black,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            width: 2,
                            color: Colors.black,
                          ),
                        ),
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
                          style: const TextStyle(
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
                        ),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SearchPage()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Vertical list of all books
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      shrinkWrap: true, // Important to make ListView scroll within SingleChildScrollView
                      physics: const NeverScrollableScrollPhysics(), // Prevent internal scroll
                      itemCount: widget.books.length,
                      itemBuilder: (context, index) {
                        final book = widget.books[index];
                        final bookState = bookStates[book.id]; // Get the current state of the book

                        return GestureDetector(
                          onTap: () {
                            // Navigate to the BookDetail screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookDetail(book: book),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                            ),
                            margin: const EdgeInsets.all(8.0),
                            padding: const EdgeInsets.all(4.0),
                            width: 150, // Match the width of the image
                            child: Row(
                              children: [
                                Image.network(
                                  book.volumeInfo.imageLinks?['thumbnail']?.toString() ??
                                      'https://lh3.googleusercontent.com/proxy/4z1e5tJL9nhsfFc6X3jsElJ_xOvo1uuiiCb5J_qdv7ZjOw5J4bzP1E3FdFbYBlvQpcIs7kgXC2xcKovRP-L2cGEop_IXbL3P1SauzTkY',
                                  width: 100,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(width: 8.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        book.volumeInfo.title,
                                        overflow: TextOverflow.ellipsis,
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
                                      const SizedBox(height: 4), // Space between authors and description
                                      Text(
                                        book.volumeInfo.description,
                                        overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
                                        maxLines: 2, // Allow for four lines for the description
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      Text(
                                        'Rating: ${book.volumeInfo.averageRating}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      Text(
                                        'Pages: ${book.volumeInfo.pageCount}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        textAlign: TextAlign.end,
                                      ),
                                      Row(
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              // Navigate to the BookDetail screen
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      BookDetail(book: book),
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              shape: const BeveledRectangleBorder(),
                                              backgroundColor: Colors.orangeAccent,
                                              foregroundColor: Colors.black,
                                              padding: const EdgeInsets.all(12.0),
                                              textStyle: const TextStyle(fontSize: 18),
                                            ),
                                            child: const Text('Read Preview'),
                                          ),
                                          const SizedBox(width: 8),
                                          ElevatedButton(
                                            onPressed: bookState == null
                                                ? () async {
                                                    // Add book to shelf using SQLite
                                                    await DBHelper().insertReadingFromGoogleApi(book);
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(
                                                        content: Text('Book added to your shelf!'),
                                                      ),
                                                    );
                                                    setState(() {
                                                      bookStates[book.id] = 'Planned'; // Update state
                                                    });
                                                  }
                                                : null, // Disable button if book already added
                                            style: ElevatedButton.styleFrom(
                                              shape: const BeveledRectangleBorder(),
                                              foregroundColor: Colors.black,
                                              backgroundColor: Colors.orangeAccent,
                                              padding: const EdgeInsets.all(12.0),
                                              textStyle: const TextStyle(fontSize: 18),
                                            ),
                                            child: bookState != null
                                                ? Text(bookState) // Show current state (e.g., Planned)
                                                : const Text('Add to Shelf'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
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
