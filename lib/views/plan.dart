import 'package:flutter/material.dart';
import 'package:kitablog/views/account.dart';

class Plan extends StatefulWidget {
  const Plan({super.key, });

  @override
  State<Plan> createState() => _PlanState();
}

class _PlanState extends State<Plan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: const Center(
              child: Text('Planning your reading journey, Coming soon!'),

            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Account()));
            },
            child: const Text('Made with ❤️ by Dave RaGoose'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}