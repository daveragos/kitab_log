import 'package:flutter/material.dart';
import 'package:google_books_api/google_books_api.dart';
import 'package:kitablog/views/book_detail.dart';

class SavedBookList extends StatelessWidget {
  final List<Book> books;

  const SavedBookList({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Results')),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return ListTile(
            title: Text(book.volumeInfo.title),
            subtitle: Text(book.volumeInfo.subtitle),
            leading: Image.network(book.volumeInfo.imageLinks?['thumbnail'].toString() ??
            'https://lh3.googleusercontent.com/proxy/4z1e5tJL9nhsfFc6X3jsElJ_xOvo1uuiiCb5J_qdv7ZjOw5J4bzP1E3FdFbYBlvQpcIs7kgXC2xcKovRP-L2cGEop_IXbL3P1SauzTkY'),
            onTap: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookDetail(book: book),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
