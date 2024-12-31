import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserProfile(username: "John Doe"),
    );
  }
}

class UserProfile extends StatefulWidget {
  final String username;

  const UserProfile({super.key, required this.username});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController waterQualityController = TextEditingController();
  final TextEditingController waterLevelController = TextEditingController();

  // Change Password Controllers
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isLoading = false;

  // Save Preferences API Call
  Future<void> _savePreferences() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      final String minQuality = waterQualityController.text;
      final String minLevel = waterLevelController.text;

      final url =
          Uri.parse('https://ietp-smart-water-server.onrender.com/user');

      try {
        final response = await http.patch(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "username": widget.username,
            "minQuality": double.parse(minQuality),
            "minLevel": double.parse(minLevel),
          }),
        );

        final responseData = jsonDecode(response.body);

        if (responseData['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Preferences saved successfully!")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed: ${responseData['data']}")),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error saving preferences: $error")),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

Future<void> _changePassword() async {
    final oldPassword = oldPasswordController.text;
    final newPassword = newPasswordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All password fields are required.")),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("New passwords do not match.")),
      );
      return;
    }

    final url = Uri.parse(
        'https://ietp-smart-water-server.onrender.com/user/update-password');
    // final url = Uri.parse('https://3qphcqlw-3000.uks1.devtunnels.ms/user');

    try {
      final response = await http.patch(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": widget.username,
          "password": oldPassword,
          "newPassword": newPassword,
        }),
      );

      print(response.body); // Debugging line

      try {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Password changed successfully!")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed: ${responseData['data']}")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid server response.")),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error changing password: $error")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue.shade100,
                child: const Icon(Icons.person, size: 60, color: Colors.blue),
              ),
              const SizedBox(height: 16),
              Text(
                "Welcome, ${widget.username}!",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 30),

              // Set Preferences Section
              ExpansionTile(
                leading: const Icon(Icons.settings),
                title: const Text("Set Preferences"),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Water Quality Field
                        TextFormField(
                          controller: waterQualityController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Alert when water quality drops below:",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.water_drop),
                            suffixText: '%',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter a water quality percentage.";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // Water Level Field
                        TextFormField(
                          controller: waterLevelController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Alert when water level is below:",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.layers),
                            suffixText: '%',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter a water level percentage.";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _savePreferences,
                          child: const Text("Save Preferences"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const Divider(),

              // Change Password Section
              ExpansionTile(
                leading: const Icon(Icons.lock),
                title: const Text("Change Password"),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: oldPasswordController,
                          decoration: const InputDecoration(
                            labelText: "Current Password",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: newPasswordController,
                          decoration: const InputDecoration(
                            labelText: "New Password",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: confirmPasswordController,
                          decoration: const InputDecoration(
                            labelText: "Confirm Password",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _changePassword,
                          child: const Text("Change Password"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
