import 'package:kitablog/views/account.dart';
import 'package:kitablog/views/shelf.dart';
import 'package:kitablog/views/explore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 1;

  final List<Widget> _children = [
    const Shelf(),
    const Explore(),
    const Account(),
  ];

  final List<Widget> _items = [
    const Icon(Icons.library_books),
    const Icon(Icons.explore),
    const Icon(Icons.person),
  ];

  Widget getBody() {
    return _children[_selectedIndex];
  }

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
                  border: Border.all(
                    width: 2,
                  )
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
                        )
                      ),
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
                          'KITABlog',
                          style:  TextStyle(
                            fontSize: 24,
                            fontFamily: 'Roboto',
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
                ),
              ),
              // Display the currently selected child view
              Container(
                height: MediaQuery.of(context).size.height - 120, // Adjust height based on the bottom navigation bar
                child: getBody(),
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
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: Colors.transparent,
        color: Colors.orangeAccent[100]!,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 500),
      ),
    );
  }
}
