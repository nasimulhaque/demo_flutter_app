import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class DeviceInfoScreen extends StatefulWidget {
  const DeviceInfoScreen({super.key});

  @override
  State<DeviceInfoScreen> createState() => _DeviceInfoScreenState();
}

class _DeviceInfoScreenState extends State<DeviceInfoScreen> {
  Map<String, String> _deviceInfo = {};
  String _connectionStatus = 'Unknown';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getDeviceInfo();
    _checkConnectivity();
  }

  Future<void> _getDeviceInfo() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Theme.of(context).platform == TargetPlatform.android) {
      final androidInfo = await deviceInfo.androidInfo;
      setState(() {
        _deviceInfo = {
          'Model': androidInfo.model,
          'Manufacturer': androidInfo.manufacturer,
          'Android Version': androidInfo.version.release,
          'SDK Version': androidInfo.version.sdkInt.toString(),
          'Device': androidInfo.device,
          'Product': androidInfo.product,
          'Brand': androidInfo.brand,
          'Hardware': androidInfo.hardware,
        };
        _isLoading = false;
      });
    } else {
      final iosInfo = await deviceInfo.iosInfo;
      setState(() {
        _deviceInfo = {
          'Model': iosInfo.model,
          'iOS Version': iosInfo.systemVersion,
          'Name': iosInfo.name,
          'System Name': iosInfo.systemName,
          'Localized Model': iosInfo.localizedModel,
        };
        _isLoading = false;
      });
    }
  }

  Future<void> _checkConnectivity() async {
    final connectivity = Connectivity();
    final result = await connectivity.checkConnectivity();

    setState(() {
      _getConnectionText(result);
    });

    connectivity.onConnectivityChanged.listen((List<ConnectivityResult> result) {
      setState(() {
        _getConnectionText(result);
      });
    });
  }

  void _getConnectionText(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.wifi)) {
      _connectionStatus = 'Connected to Wi-Fi 📶';
    } else if (results.contains(ConnectivityResult.mobile)) {
      _connectionStatus = 'Connected to Mobile Data 📱';
    } else if (results.contains(ConnectivityResult.none) || results.isEmpty) {
      _connectionStatus = 'No Internet Connection ❌';
    } else {
      _connectionStatus = 'Connected 🌐';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Information'),
        backgroundColor: Colors.blue,
      ),
      body: RefreshIndicator(
        onRefresh: _getDeviceInfo,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
          children: [
            // Connection Status Card
            Card(
              color: _connectionStatus.contains('Wi-Fi') || _connectionStatus.contains('Mobile')
                  ? Colors.green.shade50
                  : Colors.red.shade50,
              margin: const EdgeInsets.all(16),
              child: ListTile(
                leading: Icon(
                  _connectionStatus.contains('Wi-Fi') || _connectionStatus.contains('Mobile')
                      ? Icons.wifi
                      : Icons.signal_wifi_off,
                  color: _connectionStatus.contains('Wi-Fi') || _connectionStatus.contains('Mobile')
                      ? Colors.green
                      : Colors.red,
                ),
                title: const Text('Network Status'),
                subtitle: Text(_connectionStatus),
              ),
            ),

            // Device Info Card
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.devices, color: Colors.blue),
                        const SizedBox(width: 8),
                        const Text(
                          'Device Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 8),
                    ..._deviceInfo.entries.map((entry) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 120,
                            child: Text(
                              '${entry.key}:',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              entry.value,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ),

            // Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                color: Colors.blue.shade50,
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue),
                      SizedBox(height: 4),
                      Text(
                        'Device info uses device_info_plus package.\n'
                            'Network status uses connectivity_plus package.\n'
                            'Pull down to refresh device info.',
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}