import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Import for date formatting

class HistoryScreen extends StatefulWidget {
  final String username; // Accept username to display usage history

  const HistoryScreen({super.key, required this.username});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<dynamic> usageHistory = [];
  bool isLoading = true;
  String errorMessage = '';

  // Function to fetch the usage history
  Future<void> fetchUsageHistory() async {
    try {
      final response = await http.get(Uri.parse(
          'https://3qphcqlw-3000.uks1.devtunnels.ms/user/usage-history/${widget.username}'));

      if (response.statusCode == 200) {
        var decodedResponse = json.decode(response.body);

        // Check if the expected keys exist
        if (decodedResponse is Map &&
            decodedResponse['body'] != null &&
            decodedResponse['body']['usageHistory'] != null &&
            decodedResponse['body']['usageHistory'] is List) {
          setState(() {
            usageHistory = decodedResponse['body']['usageHistory'];
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = 'Unexpected response format or empty usage history';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Failed to load usage history';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUsageHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : ListView.builder(
                  itemCount: usageHistory.length,
                  itemBuilder: (context, index) {
                    // Check if the list is non-empty before accessing
                    if (index < usageHistory.length) {
                      final history = usageHistory[index];
                      final date = DateTime.parse(history['date']);
                      final formattedDate = DateFormat.yMMMd().format(date);

                      return ListTile(
                        title: Text('Username: ${widget.username}'),
                        subtitle: Text(
                            'Date: $formattedDate, Volume: ${double.parse(history['volume']) * 1000} L'),
                      );
                    } else {
                      return const Center(
                        child: Text("No history available"),
                      ); // Placeholder for empty index
                    }
                  },
                ),
    );
  }
}
