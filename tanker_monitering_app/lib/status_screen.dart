import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StatusScreen extends StatefulWidget {
  final String username;

  const StatusScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  String _status = "Water Level";
  Map<String, double> _statusValues = {
    "Water Level": 0.0,
    "Turbidity": 0.0,
    "Temperature": 0.0,
  };
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDeviceData();
  }

  // Fetch data from the API and update the status values
  Future<void> _fetchDeviceData() async {
    try {
      final response = await http.get(Uri.parse('https://ietp-smart-water-server.onrender.com/user/${widget.username}'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success' && data['data'] != null) {
          final deviceData = data['data']['user']['device'];
          setState(() {
            _statusValues = {
              "Water Level": (deviceData['waterLevel'] ?? 0.0).toDouble(),
              "Turbidity": (deviceData['turbidity'] ?? 0.0).toDouble(),
              "Temperature": (deviceData['temperature'] ?? 0.0).toDouble(),
            };
            _isLoading = false;
          });
        } else {
          print('Error: Invalid response data');
        }
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  // Update the status to reflect the selected parameter
  void _updateStatus(String status) {
    setState(() {
      _status = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const Spacer(),
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: PieChart(
                          PieChartData(
                            sections: [
                              PieChartSectionData(
                                color: Colors.lightBlue,
                                value: _statusValues[_status]!,
                                title: '',
                                radius: 60,
                              ),
                              PieChartSectionData(
                                color: Colors.grey,
                                value: 100 - _statusValues[_status]!,
                                title: '',
                                radius: 60,
                              ),
                            ],
                            centerSpaceRadius: 50,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${_statusValues[_status]!.toInt()}${_status == "Temperature" ? "°C" : "%"}",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          Text(
                            _status,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _statusButton(
                        icon: Icons.water_drop,
                        label: "Water Level",
                        color: Colors.lightBlue,
                        onPressed: () => _updateStatus("Water Level"),
                      ),
                      _statusButton(
                        icon: Icons.lightbulb,
                        label: "Turbidity",
                        color: Colors.pinkAccent,
                        onPressed: () => _updateStatus("Turbidity"),
                      ),
                      _statusButton(
                        icon: Icons.thermostat,
                        label: "Temperature",
                        color: Colors.purpleAccent,
                        onPressed: () => _updateStatus("Temperature"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
    );
  }

  Widget _statusButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 30,
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
