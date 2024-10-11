import 'package:flutter/material.dart';
import 'dart:async';

import 'package:gif/gif.dart';
import 'package:kitablog/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late GifController _gifController;

  @override
  void initState() {
    super.initState();

    _gifController = GifController(vsync: this);
    _gifController.repeat(min: 0.0, max: 1.0, period: const Duration(seconds: 3)); // Adjust this according to your GIF

    // Simulate a loading time (e.g., 3 seconds) then navigate to the main screen.
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()), // Replace with your main app screen
      );
    });
  }

  @override
  void dispose() {
    _gifController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Gif(
          controller: _gifController,
          image: const AssetImage('assets/animated_splash.gif'), // Your GIF file
        ),
      ),
    );
  }
}
