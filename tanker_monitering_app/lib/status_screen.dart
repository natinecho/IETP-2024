import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({Key? key}) : super(key: key);

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  String _status = "Water Level";
  Map<String, double> _statusValues = {
    "Water Level": 85,
    "Turbidity": 90,
    "Temperature": 65,
  };

  void _updateStatus(String status) {
    setState(() {
      _status = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
