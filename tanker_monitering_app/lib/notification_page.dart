import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'home_screen.dart';

class NotificationPage extends StatefulWidget {
  final String username;

  const NotificationPage({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Map<String, dynamic>> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserDataAndNotify();
  }

  Future<void> fetchUserDataAndNotify() async {
    const userApiUrl = 'https://ietp-smart-water-server.onrender.com/user/';
    const notificationApiUrl =
        'https://3qphcqlw-3000.uks1.devtunnels.ms/user/notification';

    try {
      // Step 1: Fetch user data
      final userResponse = await http.get(
        Uri.parse('$userApiUrl${widget.username}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (userResponse.statusCode != 200) {
        throw Exception('Failed to fetch user data');
      }

      final userData = jsonDecode(userResponse.body);
      if (userData["status"] != "success") {
        throw Exception('User data fetch unsuccessful');
      }

      final device = userData["data"]["user"]["device"];
      final waterLevel = device["waterLevel"];
      final turbidity = device["turbidity"];

      // Step 2: Send data to notification API
      final notificationResponse = await http.post(
        Uri.parse(notificationApiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "username": widget.username,
          "waterLevel": waterLevel,
          "turbidity": turbidity,
        }),
      );

      if (notificationResponse.statusCode != 200) {
        throw Exception('Failed to fetch notifications');
      }

      final notificationData = jsonDecode(notificationResponse.body);
      if (notificationData["status"] != "success") {
        throw Exception('Notification fetch unsuccessful');
      }

      final body = notificationData["body"];
      setState(() {
        // Step 3: Populate notifications list
        if (body["waterLevelNotification"] == true) {
          notifications.add({
            "title": "Water Level Alert",
            "body": "Water level is at $waterLevel%",
            "icon": Icons.water_drop,
            "color": Colors.blue,
          });
        }
        if (body["turbidityNotification"] == true) {
          notifications.add({
            "title": "Turbidity Alert",
            "body": "Turbidity is at $turbidity NTU",
            "icon": Icons.warning_amber_rounded,
            "color": Colors.orange,
          });
        }
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notifications",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notifications.isEmpty
              ? const Center(
                  child: Text(
                    "No notifications available",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16.0),
                          leading: Icon(
                            notification["icon"],
                            color: notification["color"],
                            size: 36,
                          ),
                          title: Text(
                            notification["title"],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            notification["body"],
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(
                                  username: widget.username,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
