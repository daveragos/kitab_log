import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Me'),
                backgroundColor: Colors.orangeAccent[100]!,

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hi! I\'m Dawit Beyene',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const SizedBox(height: 8),
            const Text(
              'Flutter Developer | Mobile App Creator',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            const Text(
              'About Me',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'I create functional mobile applications using Flutter. I focus on developing user-friendly apps that improve daily tasks.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 20),
            const Text(
              'Connect with Me!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.link, color: Colors.teal),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    // Add your GitHub link here
                    launchUrl(Uri.parse('https://github.com/daveragos'));
                  },
                  child: const Text(
                    'My GitHub Profile',
                    style: TextStyle(fontSize: 16, color: Colors.teal, decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.yellow),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    // Add your GitHub repo link here
                    launchUrl(Uri.parse('https://github.com/daveragos/kitab_log'));
                  },
                  child: const Text(
                    '⭐ Star My Repository',
                    style: TextStyle(fontSize: 16, color: Colors.teal, decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
