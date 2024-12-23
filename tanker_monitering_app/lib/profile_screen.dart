import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserProfile(),
    );
  }
}

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController usernameController =
      TextEditingController(text: "JohnDoe");
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController waterQualityController = TextEditingController();
  final TextEditingController waterLevelController = TextEditingController();

  bool isAuthenticated = false;
  bool isPasswordVisible = false;
  String? userWaterQuality = '30%';
  String? userWaterLevel = '30%';

  void _authenticate() {
    if (passwordController.text.isNotEmpty) {
      setState(() {
        isAuthenticated = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your password.")),
      );
    }
  }

  void _savePreferences() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preferences Saved Successfully")),
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

              // Welcome Section
              Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue.shade100,
                    child:
                        const Icon(Icons.person, size: 60, color: Colors.blue),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Welcome, ${usernameController.text}!",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Please enter your password to change preferences.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                ],
              ),

              // Password and Unlock Button Row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: !isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: "Enter Password",
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password is required to proceed.";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _authenticate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Enter",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Preferences Section (Visible after authentication)
              if (isAuthenticated) ...[
                const Divider(thickness: 1),
                const SizedBox(height: 30),
                const Text(
                  "Set Your Preferences",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: waterQualityController..text = userWaterQuality!,
                  onChanged: (value) {
                    setState(() {
                      userWaterQuality = value;
                    });
                  },
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
                const SizedBox(height: 20),
                TextFormField(
                  controller: waterLevelController..text = userWaterLevel!,
                  onChanged: (value) {
                    setState(() {
                      userWaterLevel = value;
                    });
                  },
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
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _savePreferences,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Save Preferences",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
