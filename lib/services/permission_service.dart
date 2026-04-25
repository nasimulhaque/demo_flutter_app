import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService extends ChangeNotifier {
  Map<Permission, PermissionStatus> _statuses = {};

  Map<Permission, PermissionStatus> get statuses => _statuses;

  // Request single permission
  Future<bool> requestPermission(Permission permission) async {
    final status = await permission.request();
    _updateStatus(permission, status);
    return status.isGranted;
  }

  // Request multiple permissions
  Future<Map<Permission, PermissionStatus>> requestPermissions(
      List<Permission> permissions,
      ) async {
    final results = await permissions.request();
    _statuses = results;
    notifyListeners();
    return results;
  }

  // Check permission status
  Future<bool> checkPermission(Permission permission) async {
    final status = await permission.status;
    _updateStatus(permission, status);
    return status.isGranted;
  }

  // Handle permission with rationale
  Future<bool> handlePermission(Permission permission) async {
    final status = await permission.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      final result = await permission.request();
      return result.isGranted;
    }

    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }

    return false;
  }

  // Open app settings
  Future<bool> openSettings() async {
    return await openAppSettings();
  }

  void _updateStatus(Permission permission, PermissionStatus status) {
    _statuses[permission] = status;
    notifyListeners();
  }

  // Get all permissions status
  Future<void> checkAllPermissions() async {
    _statuses = {
      Permission.camera: await Permission.camera.status,
      Permission.location: await Permission.location.status,
      Permission.storage: await Permission.storage.status,
      Permission.activityRecognition: await Permission.activityRecognition.status,
    };
    notifyListeners();
  }

  String getPermissionStatusText(PermissionStatus status) {
    if (status.isGranted) return 'Granted';
    if (status.isDenied) return 'Denied';
    if (status.isPermanentlyDenied) return 'Permanently Denied';
    if (status.isLimited) return 'Limited';
    return 'Unknown';
  }

  Color getPermissionStatusColor(PermissionStatus status) {
    if (status.isGranted) return Colors.green;
    if (status.isDenied) return Colors.orange;
    if (status.isPermanentlyDenied) return Colors.red;
    return Colors.grey;
  }
}