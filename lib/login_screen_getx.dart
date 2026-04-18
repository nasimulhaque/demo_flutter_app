import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/auth_controller.dart';

class LoginScreenGetX extends StatelessWidget {
  const LoginScreenGetX({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('GetX Login'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: authController.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.trending_up, size: 80, color: Colors.purple),
              const SizedBox(height: 30),
              TextFormField(
                controller: authController.emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Email required';
                  if (!value.contains('@')) return 'Invalid email';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: authController.passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Password required';
                  if (value.length < 6) return 'Password too short';
                  return null;
                },
              ),
              // Reactive error message using Obx
              Obx(() => authController.error.isNotEmpty
                  ? Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  authController.error.value,
                  style: const TextStyle(color: Colors.red),
                ),
              )
                  : const SizedBox.shrink()),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: Obx(() => ElevatedButton(
                  onPressed: authController.isLoading.value ? null : () async {
                    if (authController.formKey.currentState!.validate()) {
                      final success = await authController.login();
                      if (success && Get.context != null) {
                        ScaffoldMessenger.of(Get.context!).showSnackBar(
                          const SnackBar(content: Text('Login Successful!')),
                        );
                        Navigator.pop(Get.context!);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: authController.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Login', style: TextStyle(fontSize: 16)),
                )),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back to Home'),
              ),
              const SizedBox(height: 8),
              const Text(
                'Demo: demo@example.com / password123',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}