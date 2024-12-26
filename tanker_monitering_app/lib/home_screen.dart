// home_screen.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Singleton class to manage notifications
class Notifications {
  static final List<Map<String, String>> _notifications = [];

  static void addNotification({required String title, required String body}) {
    _notifications.add({"title": title, "body": body});
  }

  static List<Map<String, String>> getNotifications() {
    return _notifications;
  }
}

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({Key? key, required this.username}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  double _waterLevel = 75; // Default water level percentage
  double _totalCapacity = 2000; // Default total capacity in liters
  double _waterQuality = 0; // Default water quality
  bool _isLoading = true;
  String? _errorMessage;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _fetchWaterData();
  }

  Future<void> _fetchWaterData() async {
    final url = Uri.parse(
        "https://ietp-smart-water-server.onrender.com/user/${widget.username}");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData["status"] == "success") {
          final user = responseData["data"]["user"];
          final device = user["device"];

          setState(() {
            _totalCapacity = device["maxVolume"] ?? 2000.0;
            _waterLevel = device["waterLevel"] ?? 75.0;
            _waterQuality = device["turbidity"] ?? 0.0;
            _isLoading = false;
          });

        } else {
          setState(() {
            _errorMessage = "Failed to load data.";
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = "Error: ${response.reasonPhrase}";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "An error occurred: $e";
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        body: Center(child: Text(_errorMessage!)),
      );
    }

    Color waterColor = _waterLevel > 30 ? Colors.blue : Colors.red[200]!;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "${(_totalCapacity * (_waterLevel / 100)).toInt()} L",
                      style: const TextStyle(
                        fontSize: 33,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF132898),
                      ),
                    ),
                    Text(
                      "${(_totalCapacity - (_totalCapacity * (_waterLevel / 100))).toInt()} L used",
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            const Icon(Icons.water_drop, color: Colors.blue),
                            const SizedBox(width: 10),
                            Text(
                              "Water Quality: ${_waterQuality.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      width: double.infinity,
                      height: constraints.maxHeight * 0.6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color.fromARGB(41, 224, 224, 224),
                      ),
                    ),
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return CustomPaint(
                          size: Size(double.infinity, (constraints.maxHeight * 0.6)),
                          painter: WavePainter(
                            animationValue: _animationController.value,
                            waterLevel: _waterLevel,
                            waterColor: waterColor,
                          ),
                        );
                      },
                    ),
                    Positioned(
                      top: constraints.maxHeight * 0.3 - 20,
                      child: Text(
                        "${_waterLevel.toInt()}%",
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF132898),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double animationValue;
  final double waterLevel;
  final Color waterColor;

  WavePainter({
    required this.animationValue,
    required this.waterLevel,
    required this.waterColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint wavePaint = Paint()
      ..color = waterColor
      ..style = PaintingStyle.fill;

    double waveHeight = 20;
    double waveWidth = size.width / 2;
    double waterHeight = size.height * (waterLevel / 100);

    Path wavePath = Path();

    wavePath.moveTo(0, size.height - waterHeight);

    for (double i = 0; i <= size.width; i++) {
      double dx = i;
      double dy = sin((i / waveWidth + animationValue * 2 * pi)) * waveHeight;
      wavePath.lineTo(dx, size.height - waterHeight + dy);
    }

    wavePath.lineTo(size.width, size.height);
    wavePath.lineTo(0, size.height);
    wavePath.close();

    canvas.drawPath(wavePath, wavePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
