import 'package:flutter/material.dart';
import 'package:tanker_monitering_app/Home.dart';
import 'package:tanker_monitering_app/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/water_background.png'), // Ensure the image is in the assets folder
                fit: BoxFit.cover,
              ),
            ),
          ),

          // // Semi-transparent overlay
          Container(
            color: Colors.white.withOpacity(0.50),
          ),
          // Content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(), // Large gap between the content above and the button
              const Column(
                children: [
                  Text(
                    'WELCOME',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightBlue,
                    ),
                  ),
                  SizedBox(height: 100),
                  Text(
                    '"Monitor Water, Stay healthy!"',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      // fontFamily: "Tangerine",
                      // fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(height: 50), // Adjust this for spacing
                ],
              ),
              const Spacer(), // Large gap between the content above and the button
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => LoginPage()));
                  // Add your login logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 50), // Space below the button
            ],
          ),
        ],
      ),
    );
  }
}
