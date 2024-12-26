// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'Home.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: LoginPage(),
//     );
//   }
// }

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   bool _isLoading = false;
//   String? _errorMessage;

//   Future<void> _login() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true;
//         _errorMessage = null;
//       });

//       const url = 'https://ietp-smart-water-server.onrender.com/user/login';
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'username': usernameController.text,
//           'password': passwordController.text,
//         }),
//       );

//       setState(() {
//         _isLoading = false;
//       });

//       if (response.statusCode == 200) {
//         // Navigate to Home Page after successful login
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const Home()),
//         );
//       } else {
//         // Display error message
//         setState(() {
//           _errorMessage = 'Invalid username or password.';
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text(
//                     "Sign In",
//                     style: TextStyle(
//                       fontSize: 32,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.lightBlue,
//                       fontFamily: 'Poppins',
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   const Text.rich(
//                     TextSpan(
//                       text: "Track your ",
//                       style: TextStyle(
//                         fontSize: 15,
//                         color: Colors.black87,
//                         fontFamily: 'Poppins',
//                       ),
//                       children: [
//                         TextSpan(
//                           text: "water tanker",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.lightBlue,
//                           ),
//                         ),
//                         TextSpan(
//                           text: ", Transform your ",
//                         ),
//                         TextSpan(
//                           text: "health.",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.lightBlue,
//                           ),
//                         ),
//                       ],
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 20),
//                   TextFormField(
//                     controller: usernameController,
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: const Color.fromARGB(1, 27, 174, 130),
//                       labelText: "Username",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return "Please enter your username.";
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   TextFormField(
//                     controller: passwordController,
//                     obscureText: true,
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: const Color.fromARGB(1, 27, 174, 130),
//                       labelText: "Password",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return "Please enter your password.";
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                   if (_errorMessage != null)
//                     Text(
//                       _errorMessage!,
//                       style: const TextStyle(
//                         color: Colors.red,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   const SizedBox(height: 10),
//                   _isLoading
//                       ? const CircularProgressIndicator()
//                       : ElevatedButton(
//                           onPressed: _login,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.lightBlue, // Dark Blue
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 50,
//                               vertical: 15,
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           child: const Text(
//                             "LOGIN",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tanker_monitering_app/Home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      const url = 'https://ietp-smart-water-server.onrender.com/user/login';
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': usernameController.text,
          'password': passwordController.text,
        }),
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {

          // Navigate to Home Page with data
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Home(
                username: usernameController.text
              ),
            ),
          );
      } else {
        setState(() {
          _errorMessage = 'Invalid username or password.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Sign In",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightBlue,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text.rich(
                    TextSpan(
                      text: "Track your ",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        fontFamily: 'Poppins',
                      ),
                      children: [
                        TextSpan(
                          text: "water tanker",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlue,
                          ),
                        ),
                        TextSpan(
                          text: ", Transform your ",
                        ),
                        TextSpan(
                          text: "health.",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlue,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromARGB(1, 27, 174, 130),
                      labelText: "Username",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your username.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromARGB(1, 27, 174, 130),
                      labelText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  if (_errorMessage != null)
                    Text(
                      _errorMessage!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(height: 10),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlue,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "LOGIN",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
