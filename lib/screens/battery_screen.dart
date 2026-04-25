import 'package:flutter/material.dart';
import '../services/native_channel_service.dart';

class BatteryScreen extends StatefulWidget {
  const BatteryScreen({super.key});

  @override
  State<BatteryScreen> createState() => _BatteryScreenState();
}

class _BatteryScreenState extends State<BatteryScreen> {
  final NativeChannelService _nativeService = NativeChannelService();
  int _batteryLevel = -1;
  bool _isLoading = false;
  String? _error;

  Future<void> _getBatteryLevel() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final level = await _nativeService.getBatteryLevel();
      setState(() {
        _batteryLevel = level;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Battery Level'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Battery Icon
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                _batteryLevel > 70
                    ? Icons.battery_full
                    : _batteryLevel > 30
                    ? Icons.battery_std
                    : Icons.battery_alert,
                size: 100,
                color: _batteryLevel > 70
                    ? Colors.green
                    : _batteryLevel > 30
                    ? Colors.orange
                    : Colors.red,
              ),
            ),
            const SizedBox(height: 30),

            // Battery Level Display
            if (_batteryLevel != -1)
              Text(
                '$_batteryLevel%',
                style: const TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                ),
              ),

            const SizedBox(height: 20),

            // Loading
            if (_isLoading)
              const CircularProgressIndicator(),

            // Error
            if (_error != null)
              Text(
                'Error: $_error',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),

            const SizedBox(height: 30),

            // Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _getBatteryLevel,
                icon: const Icon(Icons.refresh),
                label: const Text('Get Battery Level'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Info Card
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(Icons.code, color: Colors.blue),
                    const SizedBox(height: 8),
                    const Text(
                      'Platform Channel Demo',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'MethodChannel communicates with native code (Kotlin/Swift)\n'
                          'to get real battery information.',
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
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