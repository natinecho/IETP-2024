import 'package:flutter/material.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  double _waterLevel = 75; // Water level percentage
  final double _totalCapacity = 2000; // Total capacity in liters
  late AnimationController _animationController;
  double get _remainingWater => _totalCapacity * (_waterLevel / 100);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color waterColor = _waterLevel > 30 ? Colors.blue : Colors.red[200]!;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "${_remainingWater.toInt()} L remaining | ${(_totalCapacity - _remainingWater).toInt()} L used",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
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
                        color: Colors.grey[300],
                      ),
                    ),
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return CustomPaint(
                          size: Size(
                              double.infinity, (constraints.maxHeight * 0.6)),
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
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _waterLevel = (Random().nextInt(101)).toDouble();
                    });
                  },
                  child: const Text("Change Water Level"),
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
