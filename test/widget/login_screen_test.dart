import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:demo_flutter_app/screens/login_screen.dart';
import 'package:demo_flutter_app/services/auth_service.dart';

void main() {
  group('LoginScreen Widget Tests', () {
    Widget createWidget() {
      return ChangeNotifierProvider(
        create: (_) => AuthService(),
        child: const MaterialApp(
          home: LoginScreen(),
        ),
      );
    }

    testWidgets('displays email and password fields', (tester) async {
      await tester.pumpWidget(createWidget());

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('displays login button', (tester) async {
      await tester.pumpWidget(createWidget());

      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('displays sign up link', (tester) async {
      await tester.pumpWidget(createWidget());

      expect(find.text("Don't have an account?"), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);
    });

    testWidgets('displays forgot password link', (tester) async {
      await tester.pumpWidget(createWidget());

      expect(find.text('Forgot Password?'), findsOneWidget);
    });

    testWidgets('shows validation error for empty email', (tester) async {
      await tester.pumpWidget(createWidget());

      // Tap login without entering email
      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(find.text('Email is required'), findsOneWidget);
    });

    testWidgets('shows validation error for invalid email', (tester) async {
      await tester.pumpWidget(createWidget());

      // Enter invalid email
      await tester.enterText(find.widgetWithText(TextField, 'Email').first, 'invalid');
      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(find.text('Enter a valid email'), findsOneWidget);
    });
  });
}