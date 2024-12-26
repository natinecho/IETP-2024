import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Controllers for user input
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _minQualityController = TextEditingController();
  final TextEditingController _minLevelController = TextEditingController();

  // Function to send data to the API
  Future<void> _saveProfile() async {
    final String username = _usernameController.text;
    final String minQuality = _minQualityController.text;
    final String minLevel = _minLevelController.text;

    if (username.isEmpty || minQuality.isEmpty || minLevel.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    final url = Uri.parse('https://ietp-smart-water-server.onrender.com/user');

    try {
      final response = await http.patch(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "minQuality": double.parse(minQuality),
          "minLevel": double.parse(minLevel),
        }),
      );

      final responseData = jsonDecode(response.body);

      if (responseData['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Profile saved successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to save profile: ${responseData['data']}")),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving profile: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.person,
                size: 100,
                color: Colors.blue,
              ),
              const SizedBox(height: 100), // Increased spacing here
              // Name Input Field
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: "Your Name",
                  hintText: "Enter your name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 30), // Increased spacing here
              // Notification for Water Quality
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      "Send notification when the water quality is:",
                      style: TextStyle(fontSize: 16),
                      softWrap: true,
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 80,
                    child: TextField(
                      controller: _minQualityController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        suffixText: "%",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30), // Increased spacing here
              // Notification for Water Level
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      "Send notification when the water level is:",
                      style: TextStyle(fontSize: 16),
                      softWrap: true,
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 80,
                    child: TextField(
                      controller: _minLevelController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        suffixText: "%",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 100), // Increased spacing here
              // Save Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  backgroundColor: Colors.blue,
                ),
                onPressed: _saveProfile,
                child: Text(
                  "Save",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
