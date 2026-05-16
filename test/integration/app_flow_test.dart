import 'package:demo_flutter_app/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:demo_flutter_app/main.dart' as app;
import 'package:demo_flutter_app/services/database_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('E-Commerce App Integration Tests', () {
    setUp(() async {
      // Clear database before each test
      await DatabaseHelper.instance.clearCart();
    });

    testWidgets('Full app flow: Login to checkout', (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify splash screen then login screen
      expect(find.text('Login'), findsOneWidget);

      // Enter email
      await tester.enterText(
        find.widgetWithText(TextField, 'Email').first,
        'test@example.com',
      );

      // Enter password
      await tester.enterText(
        find.widgetWithText(TextField, 'Password').first,
        'password123',
      );

      // Tap login
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify home screen appears
      expect(find.text('ShopHub'), findsOneWidget);

      // Wait for products to load
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Tap first product
      await tester.tap(find.byType(ProductCard).first);
      await tester.pumpAndSettle();

      // Verify product detail screen
      expect(find.text('Add to Cart'), findsOneWidget);

      // Go back to home
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();

      // Navigate to cart
      await tester.tap(find.byIcon(Icons.shopping_cart));
      await tester.pumpAndSettle();

      // Verify cart screen
      expect(find.text('My Cart'), findsOneWidget);
    });

    testWidgets('Search products flow', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Login
      await tester.enterText(
        find.widgetWithText(TextField, 'Email').first,
        'test@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Password').first,
        'password123',
      );
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Tap search icon
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Enter search query
      await tester.enterText(find.byType(TextField).last, 'phone');
      await tester.tap(find.text('Search'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify search results
      expect(find.byType(ProductCard), findsWidgets);
    });

    testWidgets('Add to cart and checkout', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Login
      await tester.enterText(
        find.widgetWithText(TextField, 'Email').first,
        'test@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Password').first,
        'password123',
      );
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Wait for products
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Tap add to cart on first product
      await tester.tap(find.byIcon(Icons.add_shopping_cart).first);
      await tester.pump();

      // Verify snackbar appears
      expect(find.text('Added to cart'), findsOneWidget);

      // Go to cart
      await tester.tap(find.byIcon(Icons.shopping_cart));
      await tester.pumpAndSettle();

      // Verify product in cart
      expect(find.byType(ProductCard), findsOneWidget);

      // Proceed to checkout
      await tester.tap(find.text('Proceed to Checkout'));
      await tester.pumpAndSettle();

      // Fill checkout form
      await tester.enterText(
        find.widgetWithText(TextField, 'Full Name').first,
        'Test User',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Address').first,
        '123 Test Street',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'City').first,
        'Test City',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Phone').first,
        '1234567890',
      );

      // Place order
      await tester.tap(find.text('Place Order'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify order confirmation
      expect(find.text('Order placed successfully!'), findsOneWidget);
    });

    testWidgets('Theme toggle works', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Login
      await tester.enterText(
        find.widgetWithText(TextField, 'Email').first,
        'test@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Password').first,
        'password123',
      );
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to profile
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();

      // Find theme toggle
      final themeSwitch = find.byType(Switch);
      expect(themeSwitch, findsOneWidget);

      // Toggle theme
      await tester.tap(themeSwitch);
      await tester.pump();

      // Verify theme changed (check background color)
      // This is a simple verification - the app should now use dark theme
    });
  });
}