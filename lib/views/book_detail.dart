import 'package:kitablog/services/db_helper.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_books_api/google_books_api.dart';

class BookDetail extends StatefulWidget {
  final Book book;

  const BookDetail({super.key, required this.book});

  @override
  _BookDetailState createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
  String? bookState;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkIfBookExists();
  }


  Future<void> _checkIfBookExists() async {
    final db = DBHelper();
    final result = await db.getReadings();
    final book = result.firstWhere(
      (reading) => reading['bookId'] == widget.book.id,
      orElse: () => {},
    );

    if (book.isNotEmpty) {
      setState(() {
        bookState = book['state'];
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookInfo = widget.book.volumeInfo;

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 350.0,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    bookInfo.title,
                    style: const TextStyle(fontSize: 16),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        bookInfo.imageLinks?['thumbnail'].toString() ??
                            'https://lh3.googleusercontent.com/proxy/4z1e5tJL9nhsfFc6X3jsElJ_xOvo1uuiiCb5J_qdv7ZjOw5J4bzP1E3FdFbYBlvQpcIs7kgXC2xcKovRP-L2cGEop_IXbL3P1SauzTkY',
                        fit: BoxFit.cover,
                      ),
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          color: Colors.black.withOpacity(0.3),
                        ),
                      ),
                      Center(
                        child: Image.network(
                          bookInfo.imageLinks?['thumbnail'].toString() ??
                              'https://lh3.googleusercontent.com/proxy/4z1e5tJL9nhsfFc6X3jsElJ_xOvo1uuiiCb5J_qdv7ZjOw5J4bzP1E3FdFbYBlvQpcIs7kgXC2xcKovRP-L2cGEop_IXbL3P1SauzTkY',
                          width: 200,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bookInfo.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Divider(
                            thickness: 1,
                            color: Colors.black,
                          ),
                          Text(
                            'Author(s): ${bookInfo.authors.join(', ')}',
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 8),

                          Text(
                            'Publisher: ${bookInfo.publisher}',
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 8),

                          Text(
                            'Category: ${bookInfo.categories.join(', ')}',
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 8),

                          Text(
                            'Published Date: ${bookInfo.publishedDate.toString().substring(0, 10)}',
                            style: const TextStyle(fontSize: 18),
                          ),
                          const Divider(
                            thickness: 1,
                            color: Colors.black,
                          ),
                          Text(
                            bookInfo.description,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const Divider(
                            thickness: 1,
                            color: Colors.black,
                          ),
                          const SizedBox(
                            height: 50,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),


          if (!isLoading)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.white.withOpacity(0.9),
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 32.0),
                child: ElevatedButton(
                  onPressed: bookState == null
                      ? () async {

                          await DBHelper()
                              .insertReadingFromGoogleApi(widget.book);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Book added to your reading list!')),
                          );
                          setState(() {
                            bookState =
                                'Planned';
                          });
                          await DBHelper().getReadings();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    shape: const BeveledRectangleBorder(),
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.orangeAccent,
                    padding: const EdgeInsets.all(12.0),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: bookState != null
                      ? Text(bookState!)
                      : const Text('Start Reading'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
