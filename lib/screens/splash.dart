import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 139, 160, 197),
      body: Center(
        child: Text('Loading .....'),
      ),
    );
  }
}
