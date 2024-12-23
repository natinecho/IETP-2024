import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text(
          "Welcome to the Profile Screen",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
