import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  String? _token;

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get token => _token;

  final _storage = const FlutterSecureStorage();

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (email == 'demo@example.com' && password == 'password123') {
      _token = 'demo_token_123';
      await _storage.write(key: 'token', value: _token);
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _error = 'Invalid email or password';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'token');
    _token = null;
    notifyListeners();
  }

  Future<bool> isLoggedIn() async {
    _token = await _storage.read(key: 'token');
    return _token != null;
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}