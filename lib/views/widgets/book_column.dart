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
                decoration: BoxDecoration(
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
                          style: TextStyle(
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
                ),
              ),
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
                          book.volumeInfo.imageLinks?['thumbnail'].toString() ??
                              'https://lh3.googleusercontent.com/proxy/4z1e5tJL9nhsfFc6X3jsElJ_xOvo1uuiiCb5J_qdv7ZjOw5J4bzP1E3FdFbYBlvQpcIs7kgXC2xcKovRP-L2cGEop_IXbL3P1SauzTkY',

                          width: 150,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 8),
                        Expanded( // Use Expanded to allow the column to take up available space
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
                              // Wrap authors in a Wrap to display them horizontally
                              Text(
                                book.volumeInfo.authors.join(', '),
                                overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
                                style: const TextStyle(
                                  decoration: TextDecoration.underline,
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
                                          builder: (context) => BookDetail(book: book),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                    shape: BeveledRectangleBorder(),
                    backgroundColor: Colors.orangeAccent,
                    foregroundColor: Colors.black,

                    padding: const EdgeInsets.all(12.0),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                                    child: const Text('Read Preview'),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Navigate to the BookDetail screen
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BookDetail(book: book),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                    shape: BeveledRectangleBorder(),
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.orangeAccent,
                    padding: const EdgeInsets.all(12.0),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                                    child: const Text('Add to Shelf'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
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
