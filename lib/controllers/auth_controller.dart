import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  var isLoading = false.obs;
  var error = ''.obs;

  final _storage = const FlutterSecureStorage();

  Future<bool> login() async {
    isLoading.value = true;
    error.value = '';

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (emailController.text == 'demo@example.com' &&
        passwordController.text == 'password123') {
      await _storage.write(key: 'token', value: 'demo_token_123');
      isLoading.value = false;
      return true;
    } else {
      error.value = 'Invalid email or password';
      isLoading.value = false;
      return false;
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'token');
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}