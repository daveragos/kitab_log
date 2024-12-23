import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:kitablog/services/api_helper.dart';
import 'package:kitablog/views/explore.dart';
import 'package:kitablog/views/plan.dart';
import 'package:kitablog/views/search.dart';
import 'package:kitablog/views/shelf.dart';
import 'package:kitablog/views/widgets/saved_book_list.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 1;
  final List<Widget> _children = [

    const Explore(),
    const Plan(),
  ];

  final List<Widget> _items = [
    const Icon(Icons.library_books),
    const Icon(Icons.explore),
    const Icon(Icons.auto_graph),
  ];

  Widget getBody() {
    return _children[_selectedIndex];
  }

  void _searchBooks(String query) async {
    final googleBooksAPI = ApiHelper();
    try {
      final results = await googleBooksAPI.getBooks(query);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SavedBookList(books: results),
        ),
      );
    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to search books: $e')),
      );
    }
  }

  Future<void> _showSearchDialog() async {
    final queryController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Search Books'),
          content: TextField(
            controller: queryController,
            decoration:
                const InputDecoration(hintText: 'Enter book title or author'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final query = queryController.text;
                if (query.isNotEmpty) {
                  _searchBooks(query);
                }
                Navigator.of(context).pop();
              },
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
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
                )),
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
                      )),
                      child: IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () {

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Not implemented yet.'),
                            ),
                          );
                        },
                      ),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'KITAB-Log',
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
                      )),
                      child:

                          IconButton(
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

              SizedBox(
                height: MediaQuery.of(context).size.height -
                    160,
                child:  _selectedIndex == 0
                    ? const Shelf()
                    : IndexedStack(
                        index: _selectedIndex - 1,
                        children: _children,
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 60,
        items: _items,
        onTap: (index) {
          if (mounted) {
  setState(() {
    _selectedIndex = index;
  });
}
        },
        backgroundColor: Colors.transparent,
        color: Colors.orangeAccent[100]!,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 500),
      ),
    );
  }
}
