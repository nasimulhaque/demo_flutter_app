import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

class PedometerScreen extends StatefulWidget {
  const PedometerScreen({super.key});

  @override
  State<PedometerScreen> createState() => _PedometerScreenState();
}

class _PedometerScreenState extends State<PedometerScreen> {
  int _stepCount = 0;
  bool _isListening = false;
  String _error = '';
  StreamSubscription<StepCount>? _subscription;

  @override
  void initState() {
    super.initState();
    _checkPermissionAndStart();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _checkPermissionAndStart() async {
    final status = await Permission.activityRecognition.request();

    if (status.isGranted) {
      _startPedometer();
    } else if (status.isPermanentlyDenied) {
      setState(() {
        _error = 'Permission permanently denied. Please enable in settings.';
      });
    } else {
      setState(() {
        _error = 'Permission denied. Cannot count steps.';
      });
    }
  }

  void _startPedometer() {
    _subscription = Pedometer.stepCountStream.listen(
          (StepCount event) {
        if (!mounted) return;
        setState(() {
          _stepCount = event.steps;
          _isListening = true;
        });
      },
      onError: (error) {
        if (!mounted) return;
        setState(() {
          _error = error.toString();
          _isListening = false;
        });
      },
    );
  }

  void _openSettings() {
    openAppSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedometer'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Step Counter Display
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.deepOrange.shade50,
                border: Border.all(color: Colors.deepOrange, width: 5),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.directions_walk,
                      size: 40,
                      color: Colors.deepOrange,
                    ),
                    Text(
                      '$_stepCount',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                    ),
                    const Text('Steps Today'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Goal Progress
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Daily Goal Progress'),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: _stepCount / 10000,
                      backgroundColor: Colors.grey.shade200,
                      color: Colors.deepOrange,
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    const SizedBox(height: 8),
                    Text('${(_stepCount / 10000 * 100).toStringAsFixed(0)}% of 10,000 steps'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Status
            if (_error.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      _error,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _openSettings,
                      child: const Text('Open Settings'),
                    ),
                  ],
                ),
              ),

            if (!_isListening && _error.isEmpty)
              const CircularProgressIndicator(),

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
                      'Step counter uses device sensors.\n'
                          'Requires ACTIVITY_RECOGNITION permission.\n'
                          'Walk around to see step count update!',
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
}