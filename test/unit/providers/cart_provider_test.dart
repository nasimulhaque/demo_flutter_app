import 'package:flutter_test/flutter_test.dart';
import 'package:demo_flutter_app/providers/cart_provider.dart';
import 'package:demo_flutter_app/models/product.dart';

void main() {
  group('CartProvider Tests', () {
    late CartProvider cartProvider;
    late Product testProduct;

    setUp(() {
      cartProvider = CartProvider();
      testProduct = Product(
        id: 1,
        title: 'Test Product',
        description: 'Test Description',
        price: 100.0,
        discountPercentage: 0,
        rating: 4.5,
        brand: 'TestBrand',
        category: 'Test',
        thumbnail: 'https://example.com/image.jpg',
        images: [],
        stock: 10,
      );
    });

    test('initial cart should be empty', () {
      expect(cartProvider.items.isEmpty, true);
      expect(cartProvider.itemCount, 0);
      expect(cartProvider.subtotal, 0);
      expect(cartProvider.tax, 0);
      expect(cartProvider.total, 0);
    });

    test('addToCart should add product', () async {
      await cartProvider.addToCart(testProduct);

      expect(cartProvider.items.length, 1);
      expect(cartProvider.items.first.productId, testProduct.id);
      expect(cartProvider.items.first.title, testProduct.title);
    });

    test('addToCart should update quantity for existing product', () async {
      await cartProvider.addToCart(testProduct);
      await cartProvider.addToCart(testProduct);

      expect(cartProvider.items.length, 1);
      expect(cartProvider.items.first.quantity, 2);
    });

    test('removeFromCart should remove product', () async {
      await cartProvider.addToCart(testProduct);
      expect(cartProvider.items.length, 1);

      await cartProvider.removeFromCart(testProduct.id);
      expect(cartProvider.items.isEmpty, true);
    });

    test('updateQuantity should update quantity', () async {
      await cartProvider.addToCart(testProduct);
      expect(cartProvider.items.first.quantity, 1);

      await cartProvider.updateQuantity(testProduct.id, 3);
      expect(cartProvider.items.first.quantity, 3);
    });

    test('updateQuantity with zero should remove product', () async {
      await cartProvider.addToCart(testProduct);
      expect(cartProvider.items.length, 1);

      await cartProvider.updateQuantity(testProduct.id, 0);
      expect(cartProvider.items.isEmpty, true);
    });

    test('clearCart should remove all items', () async {
      await cartProvider.addToCart(testProduct);
      await cartProvider.addToCart(testProduct);
      expect(cartProvider.items.length, 1); // Same product, quantity 2

      await cartProvider.clearCart();
      expect(cartProvider.items.isEmpty, true);
    });

    test('subtotal should calculate correctly', () async {
      await cartProvider.addToCart(testProduct);
      await cartProvider.updateQuantity(testProduct.id, 2);

      expect(cartProvider.subtotal, 200.0);
    });

    test('tax should be 10% of subtotal', () async {
      await cartProvider.addToCart(testProduct);
      await cartProvider.updateQuantity(testProduct.id, 2);

      expect(cartProvider.tax, 20.0);
    });

    test('total should be subtotal + tax', () async {
      await cartProvider.addToCart(testProduct);
      await cartProvider.updateQuantity(testProduct.id, 2);

      expect(cartProvider.total, 220.0);
    });
  });
}