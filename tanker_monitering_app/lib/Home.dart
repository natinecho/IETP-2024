// import 'package:flutter/material.dart';
// import 'home_screen.dart';
// import 'status_screen.dart';
// import 'profile_screen.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: const Home(),
//     );
//   }
// }

// class Home extends StatefulWidget {
//   const Home({Key? key, required String username}) : super(key: key);

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   int _currentIndex = 0; // Default tab: Status

//   final List<String> _pageTitles = ["Home", "Status", "Profile"];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_pageTitles[_currentIndex]),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.notifications),
//             onPressed: () {
//               // Handle notification icon tap
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text("Notifications clicked!")),
//               );
//             },
//           ),
//         ],
//         backgroundColor: Colors.blue,
//       ),
//       body: _currentIndex == 0
//           ? const HomeScreen()
//           : _currentIndex == 1
//               ? const StatusScreen()
//               :  ProfilePage(),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: "Home",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.bar_chart),
//             label: "Status",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: "Profile",
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:tanker_monitering_app/notification_page.dart';
import 'home_screen.dart';
import 'status_screen.dart';
import 'profile_screen.dart';

class Home extends StatefulWidget {
  final String username;

  const Home({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<String> _pageTitles = ["Home", "Status", "Profile"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          _pageTitles[_currentIndex],
          style: const TextStyle(
            color: Color(0xFF132898),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            color: Color(0xFF132898),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NotificationPage(
                    username: widget.username,
                  ),
                ),
              );
            },
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _currentIndex == 0
          ? HomeScreen(username: widget.username)
          : _currentIndex == 1
              ? StatusScreen(username: widget.username)
              : ProfilePage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Status",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
