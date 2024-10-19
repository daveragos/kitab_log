import 'package:flutter/material.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final List<Map<String, String>> teamMembers = [
    {'name': 'Dawit Beyene', 'role': 'Team Leader', 'bio': 'Flutter Developer'},
    {'name': 'Dereje Kenea', 'role': 'Backend Developer', 'bio': 'Database Design'},
    {'name': 'Ayene Addisie', 'role': 'UI/UX Designer', 'bio': 'Flutter Developer'},
    {'name': 'Adugna Birhanu', 'role': 'UI/UX Designer', 'bio': 'Design Specialist'},
    {'name': 'Rabi Muluken', 'role': 'Backend Developer', 'bio': 'API Integration'},
    {'name': 'Tamene Haile', 'role': 'UI/UX Designer', 'bio': 'Design Specialist'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Our Team',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: teamMembers.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.orangeAccent,
                        child: Text(
                          teamMembers[index]['name']![0],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(teamMembers[index]['name']!),
                      subtitle: Text('${teamMembers[index]['role']} - ${teamMembers[index]['bio']}'),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'This app was developed as part of a school mobile development project.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
