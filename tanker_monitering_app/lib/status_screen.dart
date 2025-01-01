import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'dart:async'; // For Timer

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
  late Timer _dataTimer; // Timer for fetching data every 10 seconds

  @override
  void initState() {
    super.initState();
    _fetchDeviceData();
    _dataTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      _fetchDeviceData(); // Fetch new data every 10 seconds
    });
  }

  Future<void> _fetchDeviceData() async {
    final url = Uri.parse(
        "https://3qphcqlw-3000.uks1.devtunnels.ms/user/${widget.username}");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData["status"] == "success" &&
            responseData["data"] != null) {
          final user = responseData["data"]["user"];
          final device = user["device"];

          setState(() {
            // Calculate values in percentage
            double maxVolume = double.parse(device["maxVolume"]);
            double waterLevelInCubicMeters = double.parse(device["waterLevel"]);
            _statusValues["Water Level"] =
                (waterLevelInCubicMeters / maxVolume) * 100;

            _statusValues["Turbidity"] = double.parse(device["turbidity"]);
            _statusValues["Temperature"] = double.parse(device["temperature"]);

            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Update the status to reflect the selected parameter
  void _updateStatus(String status) {
    setState(() {
      _status = status;
    });
  }

  @override
  void dispose() {
    _dataTimer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
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
