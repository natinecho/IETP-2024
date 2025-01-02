import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  final String username;

  const HistoryScreen({super.key, required this.username});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<dynamic> usageHistory = [];
  bool isLoading = true;
  String errorMessage = '';

  Future<void> fetchUsageHistory() async {
    try {
      final response = await http.get(Uri.parse(
          'https://3qphcqlw-3000.uks1.devtunnels.ms/user/usage-history/${widget.username}'));

      if (response.statusCode == 200) {
        var decodedResponse = json.decode(response.body);

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

  List<Map<String, dynamic>> _generateLineChartData() {
    return usageHistory.asMap().entries.map((entry) {
      final index = entry.key.toDouble();
      final volume = double.parse(entry.value['volume']) * 1000;
      final date = entry.value['date'];
      return {
        'spot': FlSpot(index, volume),
        'date': date,
      };
    }).toList();
  }

  String _getDateForIndex(int index) {
    if (index < usageHistory.length) {
      final entry = usageHistory[index];
      final date = DateTime.parse(entry['date']);
      return DateFormat('MMM d').format(date);
    }
    return '';
  }

  double _calculateDailyConsumption() {
    final today = DateTime.now();
    return usageHistory
        .where((entry) {
          final date = DateTime.parse(entry['date']);
          return date.year == today.year &&
              date.month == today.month &&
              date.day == today.day;
        })
        .map((entry) => double.parse(entry['volume']) * 1000)
        .fold(0.0, (sum, volume) => sum + volume);
  }

  @override
  void initState() {
    super.initState();
    fetchUsageHistory();
  }

  @override
  Widget build(BuildContext context) {
    final dailyConsumption = _calculateDailyConsumption();
    final lineChartData = _generateLineChartData();

    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : usageHistory.isEmpty
                  ? const Center(child: Text("No usage history available"))
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Daily Consumption Card
                          Card(
                            elevation: 2,
                            color: Colors.grey[200],
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Daily Water Consumption',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${dailyConsumption.toStringAsFixed(2)} L',
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Line Chart
                          Expanded(
                            child: LineChart(
                              LineChartData(
                                gridData: FlGridData(show: true),
                                titlesData: FlTitlesData(
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 40,
                                      getTitlesWidget: (value, _) => Text(
                                        '${value.toInt()} L',
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                    ),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles:false,
                                    ),
                                  ),
                                  topTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                ),
                                borderData: FlBorderData(show: true),
                                lineBarsData: [
                                  LineChartBarData(
                                    isCurved: true,
                                    spots: lineChartData
                                        .map((data) => data['spot'] as FlSpot)
                                        .toList(),
                                    color:Colors.blue,
                                    barWidth: 4,
                                    belowBarData: BarAreaData(
                                      show: true,
                                      color: Colors.blue.withOpacity(0.2),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }
}
