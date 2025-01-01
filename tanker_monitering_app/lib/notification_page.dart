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
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {

    try {
      // Fetch notifications with username as a query parameter
      final response = await http.get(
        Uri.parse('https://3qphcqlw-3000.uks1.devtunnels.ms/user/notification/${widget.username}'),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch notifications');
      }

      final notificationData = jsonDecode(response.body);
      if (notificationData["status"] != "success") {
        throw Exception('Notification fetch unsuccessful');
      }

      final body = notificationData["body"];
      setState(() {
        // Populate notifications list based on response
        if (body["waterLevelNotification"] == true) {
          notifications.add({
            "title": "Water Level Alert",
            "body": "Water level is at critical levels.",
            "icon": Icons.water_drop,
            "color": Colors.blue,
          });
        }
        if (body["turbidityNotification"] == true) {
          notifications.add({
            "title": "Turbidity Alert",
            "body": "Turbidity is at concerning levels.",
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
