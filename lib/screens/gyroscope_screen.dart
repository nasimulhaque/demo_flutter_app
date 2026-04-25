import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class GyroscopeScreen extends StatefulWidget {
  const GyroscopeScreen({super.key});

  @override
  State<GyroscopeScreen> createState() => _GyroscopeScreenState();
}

class _GyroscopeScreenState extends State<GyroscopeScreen> {
  List<double> _gyroscopeValues = [0, 0, 0];
  double _rotationX = 0;
  double _rotationY = 0;

  @override
  void initState() {
    super.initState();

    gyroscopeEventStream().listen((GyroscopeEvent event) {
      if (!mounted) return;
      setState(() {
        _gyroscopeValues = [event.x, event.y, event.z];
        _rotationX += event.x * 0.05;
        _rotationY += event.y * 0.05;
      });
    });
  }

  void _resetRotation() {
    setState(() {
      _rotationX = 0;
      _rotationY = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gyroscope'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 3D Cube Simulation
            Card(
              elevation: 4,
              child: Container(
                height: 250,
                width: double.infinity,
                color: Colors.teal.shade50,
                child: Center(
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateX(_rotationX)
                      ..rotateY(_rotationY),
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.teal, Colors.blue],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: const Offset(5, 5),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'FLUTTER',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Gyroscope Values
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Rotation Rate (rad/s)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    _buildValueRow('Pitch (X)', _gyroscopeValues[0], Colors.red),
                    const SizedBox(height: 8),
                    _buildValueRow('Roll (Y)', _gyroscopeValues[1], Colors.green),
                    const SizedBox(height: 8),
                    _buildValueRow('Yaw (Z)', _gyroscopeValues[2], Colors.blue),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Reset Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _resetRotation,
                icon: const Icon(Icons.refresh),
                label: const Text('Reset Rotation'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Info
            Card(
              color: Colors.blue.shade50,
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue),
                    SizedBox(height: 4),
                    Text(
                      'Gyroscope measures rotation rate.\n'
                          'Rotate your device to see the 3D effect!',
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
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

  Widget _buildValueRow(String label, double value, Color color) {
    return Row(
      children: [
        SizedBox(width: 80, child: Text(label)),
        Expanded(
          child: LinearProgressIndicator(
            value: (value + 5) / 10, // Map -5..5 to 0..1
            backgroundColor: Colors.grey.shade200,
            color: color,
            minHeight: 6,
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 60,
          child: Text(
            value.toStringAsFixed(3),
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ),
      ],
    );
  }
}