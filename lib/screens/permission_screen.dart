import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../services/permission_service.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PermissionService>().checkAllPermissions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final permissionService = context.watch<PermissionService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Permission Manager'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          // Info Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.orange.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Permission Best Practices',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  '• Request permissions when needed\n'
                      '• Explain why you need permission\n'
                      '• Handle denied and permanently denied\n'
                      '• Provide fallback UX',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => permissionService.checkAllPermissions(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    minimumSize: const Size(double.infinity, 40),
                  ),
                  child: const Text('Refresh Status'),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              children: [
                _buildPermissionTile(
                  context,
                  permission: Permission.camera,
                  title: 'Camera',
                  description: 'Required for taking photos',
                  icon: Icons.camera,
                ),
                _buildPermissionTile(
                  context,
                  permission: Permission.location,
                  title: 'Location',
                  description: 'Required for GPS features',
                  icon: Icons.location_on,
                ),
                _buildPermissionTile(
                  context,
                  permission: Permission.storage,
                  title: 'Storage',
                  description: 'Required for saving files',
                  icon: Icons.storage,
                ),
                _buildPermissionTile(
                  context,
                  permission: Permission.activityRecognition,
                  title: 'Activity Recognition',
                  description: 'Required for step counter',
                  icon: Icons.directions_walk,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionTile(
      BuildContext context, {
        required Permission permission,
        required String title,
        required String description,
        required IconData icon,
      }) {
    final permissionService = context.watch<PermissionService>();
    final status = permissionService.statuses[permission];

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: permissionService.getPermissionStatusColor(status ?? PermissionStatus.denied)
                .withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: permissionService.getPermissionStatusColor(status ?? PermissionStatus.denied),
          ),
        ),
        title: Text(title),
        subtitle: Text(description),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: permissionService.getPermissionStatusColor(status ?? PermissionStatus.denied)
                    .withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                permissionService.getPermissionStatusText(status ?? PermissionStatus.denied),
                style: TextStyle(
                  fontSize: 12,
                  color: permissionService.getPermissionStatusColor(status ?? PermissionStatus.denied),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (status?.isPermanentlyDenied ?? false)
              TextButton(
                onPressed: () => permissionService.openSettings(),
                child: const Text('Open Settings', style: TextStyle(fontSize: 10)),
              ),
          ],
        ),
        onTap: () async {
          final granted = await permissionService.handlePermission(permission);
          if (granted && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$title permission granted!')),
            );
          }
        },
      ),
    );
  }
}