import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Donut Chart Example"),
        ),
        body: Center(
          child: SizedBox(
            height: 200, // Adjust the size of the chart
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    color: Colors.blue,
                    value: 100, // Your single data point
                    title: '100%', // Display percentage
                    radius: 60, // Adjust radius
                    titleStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
                centerSpaceRadius: 50, // Makes it a donut chart
              ),
            ),
          ),
        ),
      ),
    );
  }
}
