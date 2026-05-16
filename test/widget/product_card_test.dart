import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:demo_flutter_app/widgets/product_card.dart';
import 'package:demo_flutter_app/models/product.dart';
import 'package:demo_flutter_app/providers/cart_provider.dart';
import 'package:demo_flutter_app/providers/favorite_provider.dart';

void main() {
  group('ProductCard Widget Tests', () {
    late Product testProduct;
    bool tapCalled = false;

    setUp(() {
      testProduct = Product(
        id: 1,
        title: 'Test Product',
        description: 'This is a test product',
        price: 99.99,
        discountPercentage: 10.0,
        rating: 4.5,
        brand: 'TestBrand',
        category: 'Electronics',
        thumbnail: 'https://example.com/image.jpg',
        images: ['https://example.com/image1.jpg'],
        stock: 10,
      );
      tapCalled = false;
    });

    Widget createWidget() {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: ProductCard(
              product: testProduct,
              onTap: () {
                tapCalled = true;
              },
            ),
          ),
        ),
      );
    }

    testWidgets('displays product title', (tester) async {
      await tester.pumpWidget(createWidget());

      expect(find.text('Test Product'), findsOneWidget);
    });

    testWidgets('displays discounted price when on sale', (tester) async {
      await tester.pumpWidget(createWidget());

      // Original price with strikethrough
      expect(find.text('\$99.99'), findsOneWidget);
      // Discounted price
      expect(find.text('\$89.99'), findsOneWidget);
    });

    testWidgets('displays SALE badge when on sale', (tester) async {
      await tester.pumpWidget(createWidget());

      expect(find.text('SALE'), findsOneWidget);
    });

    testWidgets('displays rating stars', (tester) async {
      await tester.pumpWidget(createWidget());

      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      await tester.pumpWidget(createWidget());

      await tester.tap(find.byType(ProductCard));
      await tester.pump();

      expect(tapCalled, true);
    });

    testWidgets('displays add to cart icon', (tester) async {
      await tester.pumpWidget(createWidget());

      expect(find.byIcon(Icons.add_shopping_cart), findsOneWidget);
    });
  });
}