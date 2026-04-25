package com.example.demo_flutter_app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example/battery"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        io.flutter.plugin.common.MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler(
            object : io.flutter.plugin.common.MethodChannel.MethodCallHandler {
                override fun onMethodCall(call: io.flutter.plugin.common.MethodCall, result: io.flutter.plugin.common.MethodChannel.Result) {
                    if (call.method == "getBatteryLevel") {
                        val batteryLevel = getBatteryLevel()
                        if (batteryLevel != -1) {
                            result.success(batteryLevel)
                        } else {
                            result.error("UNAVAILABLE", "Battery level not available.", null)
                        }
                    } else if (call.method == "sendData") {
                        val data = call.argument<String>("data")
                        result.success("Received: $data")
                    } else {
                        result.notImplemented()
                    }
                }
            }
        )
    }

    private fun getBatteryLevel(): Int {
        val batteryLevel: Int
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP) {
            val batteryManager = getSystemService(android.content.Context.BATTERY_SERVICE) as android.os.BatteryManager
            batteryLevel = batteryManager.getIntProperty(android.os.BatteryManager.BATTERY_PROPERTY_CAPACITY)
        } else {
            batteryLevel = -1
        }
        return batteryLevel
    }
}
