import 'package:flutter/services.dart';

class NativeChannelService {
  static const MethodChannel _batteryChannel = MethodChannel('com.example/battery');

  // Get battery level from native
  Future<int> getBatteryLevel() async {
    try {
      final int batteryLevel = await _batteryChannel.invokeMethod('getBatteryLevel');
      return batteryLevel;
    } on PlatformException catch (e) {
      print('Error getting battery: ${e.message}');
      return -1;
    }
  }

  // Example of sending data to native
  Future<void> sendDataToNative(String data) async {
    try {
      await _batteryChannel.invokeMethod('sendData', {'data': data});
    } on PlatformException catch (e) {
      print('Error sending data: ${e.message}');
    }
  }
}