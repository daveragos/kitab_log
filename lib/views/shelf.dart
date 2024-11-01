import 'dart:io';
import 'package:kitablog/models/saved_book.dart';
import 'package:kitablog/services/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:kitablog/views/add_book.dart';
import 'package:kitablog/views/shelf_book_detail.dart';

class Shelf extends StatefulWidget {
  const Shelf({super.key});

  @override
  _ShelfState createState() => _ShelfState();
}

class _ShelfState extends State<Shelf> with SingleTickerProviderStateMixin {
  List<SavedBook> _allBooks = [];
  List<SavedBook> _filteredBooks = [];
  List<SavedBook> _searchedBooks = [];
  String _selectedTab = 'All';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadReadings();

    _searchController.addListener(() {
      _filterSearchResults(_searchController.text);
    });
  }

  void _loadReadings() async {
    final readings = await DBHelper().getReadings();
    setState(() {
      _allBooks = readings
          .map((reading) => SavedBook(
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
              ))
          .toList();

      _filterBooks(_selectedTab);
    });
  }

  void _filterBooks(String state) {
    if (state == 'All') {
      _filteredBooks = _allBooks;
    } else {
      _filteredBooks = _allBooks.where((book) => book.state == state).toList();
    }
    _searchedBooks = _filteredBooks;
  }

  void _filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchedBooks =
            _filteredBooks;
      });
    } else {
      setState(() {
        _searchedBooks = _filteredBooks.where((book) {
          return book.title.toLowerCase().contains(query.toLowerCase()) ||
              book.authors.toLowerCase().contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          title: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Search books...',
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.white70),
            ),
            style: const TextStyle(color: Colors.white),
          ),
          bottom: TabBar(
            onTap: (index) {
              final tabs = ['All', 'Reading', 'Planned', 'Completed'];
              final newTab = tabs[index];

              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _selectedTab = newTab;
                  _filterBooks(_selectedTab);
                });
              });
            },
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Reading'),
              Tab(text: 'Planned'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: _buildBookList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddBookScreen(onSave: _loadReadings),
              ),
            );
          },
          tooltip: 'Add Book',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildBookList() {
    if (_searchedBooks.isEmpty) {
      return const Center(child: Text('No books available'));
    }

    return ListView.builder(
      itemCount: _searchedBooks.length,
      itemBuilder: (context, index) {
        final savedBook = _searchedBooks[index];

        return GestureDetector(
          onTap: () {
            final result = Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShelfBookDetail(
                  book: savedBook,
                  onUpdate: _loadReadings,
                ),
              ),
            );

            if (result == true) {
              _loadReadings();
            }
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
            width: 150,
            child: Row(
              children: [
                Image.file(File(savedBook.imageUrl),
                    width: 150,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (BuildContext context,
                        Object error, StackTrace? stackTrace) {
                          return Image.asset(
                            'assets/book_cover.png',
                            width: 150,
                            height: 200,
                            fit: BoxFit.cover,
                          );
                  }),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        savedBook.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        savedBook.authors,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        savedBook.description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        'State: ${savedBook.state}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Rating: ${savedBook.rating}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        'Pages: ${savedBook.pages}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                        textAlign: TextAlign.end,
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
  }
}
