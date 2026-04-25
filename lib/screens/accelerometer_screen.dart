import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math' as math;
import 'dart:async';

class AccelerometerScreen extends StatefulWidget {
  const AccelerometerScreen({super.key});

  @override
  State<AccelerometerScreen> createState() => _AccelerometerScreenState();
}

class _AccelerometerScreenState extends State<AccelerometerScreen> {
  List<double> _accelerometerValues = [0, 0, 0];
  int _shakeCount = 0;
  DateTime? _lastShakeTime;
  bool _isListening = true;
  StreamSubscription<AccelerometerEvent>? _subscription;

  @override
  void initState() {
    super.initState();

    _subscription = accelerometerEventStream().listen((AccelerometerEvent event) {
      if (!_isListening || !mounted) return;

      setState(() {
        _accelerometerValues = [event.x, event.y, event.z];
        _detectShake(event);
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _detectShake(AccelerometerEvent event) {
    // Calculate magnitude of acceleration
    double acceleration = math.sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

    // Shake threshold (typical: 15-20)
    if (acceleration > 18) {
      final now = DateTime.now();
      if (_lastShakeTime == null ||
          now.difference(_lastShakeTime!) > const Duration(milliseconds: 500)) {
        setState(() {
          _shakeCount++;
          _lastShakeTime = now;
        });

        // Visual feedback
        _showShakeFeedback();
      }
    }
  }

  void _showShakeFeedback() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Shake detected! Count: $_shakeCount'),
        duration: const Duration(milliseconds: 500),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _resetShakeCount() {
    setState(() {
      _shakeCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accelerometer'),
        backgroundColor: Colors.purple,
        actions: [
          Switch(
            value: _isListening,
            onChanged: (value) {
              setState(() {
                _isListening = value;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Shake Counter
            Card(
              color: Colors.purple.shade50,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'SHAKE DETECTOR',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$_shakeCount',
                      style: const TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                    const Text('Shakes Detected'),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _resetShakeCount,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                      ),
                      child: const Text('Reset Counter'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Sensor Values
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Live Sensor Data',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    _buildSensorRow('X (Left-Right)', _accelerometerValues[0], Colors.red),
                    const SizedBox(height: 8),
                    _buildSensorRow('Y (Forward-Back)', _accelerometerValues[1], Colors.green),
                    const SizedBox(height: 8),
                    _buildSensorRow('Z (Up-Down)', _accelerometerValues[2], Colors.blue),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Info
            Card(
              color: Colors.blue.shade50,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue),
                    SizedBox(height: 8),
                    Text(
                      'Shake your phone to detect motion!\n'
                          'Accelerometer measures device acceleration in m/s².\n'
                          'Values range from -9.8 to +9.8 (gravity = 9.8).',
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

  Widget _buildSensorRow(String label, double value, Color color) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(label),
        ),
        Expanded(
          child: LinearProgressIndicator(
            value: (value + 15) / 30, // Map -15..15 to 0..1
            backgroundColor: Colors.grey.shade200,
            color: color,
            minHeight: 8,
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 50,
          child: Text(
            value.toStringAsFixed(2),
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ),
      ],
    );
  }
}