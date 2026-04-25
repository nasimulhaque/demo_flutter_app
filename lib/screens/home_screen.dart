import 'package:flutter/material.dart';
import 'battery_screen.dart';
import 'permission_screen.dart';
import 'accelerometer_screen.dart';
import 'gyroscope_screen.dart';
import 'pedometer_screen.dart';
import 'camera_screen.dart';
import 'device_info_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensor & Native Demo'),
        backgroundColor: Colors.indigo,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('Native Features'),
          _buildNavCard(
            context,
            title: 'Battery Level',
            subtitle: 'MethodChannel - Get battery percentage',
            icon: Icons.battery_alert,
            color: Colors.green,
            screen: const BatteryScreen(),
          ),
          _buildNavCard(
            context,
            title: 'Device Information',
            subtitle: 'Get device model, OS version',
            icon: Icons.devices,
            color: Colors.blue,
            screen: const DeviceInfoScreen(),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Permissions'),
          _buildNavCard(
            context,
            title: 'Permission Manager',
            subtitle: 'Request and manage permissions',
            icon: Icons.security,
            color: Colors.orange,
            screen: const PermissionScreen(),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Sensors'),
          _buildNavCard(
            context,
            title: 'Accelerometer',
            subtitle: 'Shake detection & acceleration',
            icon: Icons.sensors,
            color: Colors.purple,
            screen: const AccelerometerScreen(),
          ),
          _buildNavCard(
            context,
            title: 'Gyroscope',
            subtitle: 'Rotation detection',
            icon: Icons.rotate_right,
            color: Colors.teal,
            screen: const GyroscopeScreen(),
          ),
          _buildNavCard(
            context,
            title: 'Pedometer',
            subtitle: 'Step counter',
            icon: Icons.directions_walk,
            color: Colors.deepOrange,
            screen: const PedometerScreen(),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Camera & Media'),
          _buildNavCard(
            context,
            title: 'Camera & Gallery',
            subtitle: 'Take photos, pick from gallery',
            icon: Icons.camera_alt,
            color: Colors.red,
            screen: const CameraScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.indigo,
        ),
      ),
    );
  }

  Widget _buildNavCard(
      BuildContext context, {
        required String title,
        required String subtitle,
        required IconData icon,
        required Color color,
        required Widget screen,
      }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
      ),
    );
  }
}