import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

void main() {
  runApp(const Home());
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 1; // Default tab: Status

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: _currentIndex == 0
            ? const HomeScreen()
            : _currentIndex == 1
                ? const StatusScreen()
                : const ProfileScreen(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: "Status",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}

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
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Colors.blue,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              // Text showing remaining and total capacity
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
              // Water level container with wave animation
              Expanded(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    // Fixed background container
                    Container(
                      width: double.infinity,
                      height: constraints.maxHeight *
                          0.6, // Adjust to available space
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[300], // Background color
                      ),
                    ),
                    // Wave and water level container
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
                    // Percentage overlay in the center
                    Positioned(
                      top: constraints.maxHeight * 0.3 -
                          20, // Center dynamically
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
              // Button to change water level for demonstration
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // Change water level between 0 and 100 randomly for demo
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

    double waveHeight = 20; // Height of the wave
    double waveWidth = size.width / 2; // Width of one wave cycle
    double waterHeight =
        size.height * (waterLevel / 100); // Water height based on percentage

    Path wavePath = Path();

    wavePath.moveTo(0, size.height - waterHeight);

    // Create wave effect
    for (double i = 0; i <= size.width; i++) {
      double dx = i;
      double dy = sin((i / waveWidth + animationValue * 2 * pi)) * waveHeight;
      wavePath.lineTo(dx, size.height - waterHeight + dy);
    }

    // Close the path
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

class StatusScreen extends StatefulWidget {
  const StatusScreen({Key? key}) : super(key: key);

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  String _status = "Water Level"; // Current status displayed
  Map<String, double> _statusValues = {
    "Water Level": 85, // Water Level in percentage
    "Turbidity": 90, // Turbidity in percentage
    "Temperature": 65, // Temperature in degrees Celsius
  };

  void _updateStatus(String status) {
    setState(() {
      _status = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Current Status"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications),
          ),
        ],
      ),
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

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.blue,
      ),
      body: const Center(
        child: Text(
          "Welcome to the Profile Screen",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
