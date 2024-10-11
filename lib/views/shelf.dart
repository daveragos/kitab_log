import 'dart:io';
import 'package:kitablog/models/saved_book.dart';
import 'package:kitablog/services/db_helper.dart';
import 'package:flutter/material.dart';
import 'shelf_book_detail.dart'; // Import the detailed view screen

class Shelf extends StatefulWidget {
  const Shelf({super.key});

  @override
  _ShelfState createState() => _ShelfState();
}

class _ShelfState extends State<Shelf> {
  Future<List<Map<String, dynamic>>>? _readings;

  @override
  void initState() {
    super.initState();
    _loadReadings();
  }

  void _loadReadings() {
    setState(() {
      _readings = DBHelper().getReadings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _readings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading shelf'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Your shelf is empty'));
          }

          final readings = snapshot.data!;
          return ListView.builder(
            itemCount: readings.length,
            itemBuilder: (context, index) {
              final reading = readings[index];
              final savedBook = SavedBook(
                id: reading['id'] as int?,
                bookId: reading['bookId'],
                title: reading['title'],
                subtitle: reading['subtitle'],
                authors: reading['authors'],
                description: reading['description'],
                imageUrl: reading['imageUrl'],
                publishedDate: reading['publishedDate'],
                isbn: reading['isbn'],
                publisher: reading['publisher'],
                pages: reading['pages'],
                categories: reading['categories'],
                price: reading['price'],
                language: reading['language'],
                rating: reading['rating'],
                state: reading['state'],
                timestamp: reading['timestamp'],
              );

              return ListTile(
                leading: Image.file(
                  File(savedBook.imageUrl),
                  width: 50,
                  height: 75,
                  fit: BoxFit.cover,
                ),
                title: Text(savedBook.title),
                subtitle: Text('State: ${savedBook.state}'),
                onTap: () async {
                  // Navigate to detailed view and wait for the result
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShelfBookDetail(
                        book: savedBook,
                        onUpdate: _loadReadings, // Refresh the list after updates
                      ),
                    ),
                  );

                  // If the result is true, reload the readings
                  if (result == true) {
                    _loadReadings();
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your logic for the floating action button
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
