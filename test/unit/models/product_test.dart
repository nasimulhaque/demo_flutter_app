import 'package:demo_flutter_app/models/product.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Product Model Tests', () {
    // Sample product data
    final Map<String, dynamic> sampleJson = {
      'id': 1,
      'title': 'Test Product',
      'description': 'This is a test product description',
      'price': 99.99,
      'discountPercentage': 10.0,
      'rating': 4.5,
      'brand': 'TestBrand',
      'category': 'Electronics',
      'thumbnail': 'https://example.com/image.jpg',
      'images': ['https://example.com/image1.jpg', 'https://example.com/image2.jpg'],
      'stock': 50,
    };

    group('fromJson', () {
      test('should create Product from JSON correctly', () {
        // Act
        final product = Product.fromJson(sampleJson);

        // Assert
        expect(product.id, 1);
        expect(product.title, 'Test Product');
        expect(product.description, 'This is a test product description');
        expect(product.price, 99.99);
        expect(product.discountPercentage, 10.0);
        expect(product.rating, 4.5);
        expect(product.brand, 'TestBrand');
        expect(product.category, 'Electronics');
        expect(product.thumbnail, 'https://example.com/image.jpg');
        expect(product.images.length, 2);
        expect(product.stock, 50);
      });

      test('should handle missing brand field', () {
        // Arrange
        final jsonWithoutBrand = Map<String, dynamic>.from(sampleJson);
        jsonWithoutBrand.remove('brand');

        // Act
        final product = Product.fromJson(jsonWithoutBrand);

        // Assert
        expect(product.brand, 'Unknown');
      });
    });

    group('toJson', () {
      test('should convert Product to JSON correctly', () {
        // Arrange
        final product = Product.fromJson(sampleJson);

        // Act
        final json = product.toJson();

        // Assert
        expect(json['id'], 1);
        expect(json['title'], 'Test Product');
        expect(json['description'], 'This is a test product description');
        expect(json['price'], 99.99);
        expect(json['discountPercentage'], 10.0);
        expect(json['rating'], 4.5);
        expect(json['brand'], 'TestBrand');
        expect(json['category'], 'Electronics');
        expect(json['thumbnail'], 'https://example.com/image.jpg');
        expect(json['images'], isA<List>());
        expect(json['stock'], 50);
      });
    });

    group('discountedPrice', () {
      test('should calculate discounted price correctly', () {
        // Arrange
        final product = Product(
          id: 1,
          title: 'Test',
          description: 'Test',
          price: 100.0,
          discountPercentage: 20.0,
          rating: 4.0,
          brand: 'Test',
          category: 'Test',
          thumbnail: '',
          images: [],
          stock: 10,
        );

        // Assert
        expect(product.discountedPrice, 80.0);
      });

      test('should return original price when discount is 0', () {
        // Arrange
        final product = Product(
          id: 1,
          title: 'Test',
          description: 'Test',
          price: 100.0,
          discountPercentage: 0.0,
          rating: 4.0,
          brand: 'Test',
          category: 'Test',
          thumbnail: '',
          images: [],
          stock: 10,
        );

        // Assert
        expect(product.discountedPrice, 100.0);
      });
    });

    group('isOnSale', () {
      test('should return true when discount > 0', () {
        // Arrange
        final product = Product(
          id: 1,
          title: 'Test',
          description: 'Test',
          price: 100.0,
          discountPercentage: 10.0,
          rating: 4.0,
          brand: 'Test',
          category: 'Test',
          thumbnail: '',
          images: [],
          stock: 10,
        );

        // Assert
        expect(product.isOnSale, true);
      });

      test('should return false when discount == 0', () {
        // Arrange
        final product = Product(
          id: 1,
          title: 'Test',
          description: 'Test',
          price: 100.0,
          discountPercentage: 0.0,
          rating: 4.0,
          brand: 'Test',
          category: 'Test',
          thumbnail: '',
          images: [],
          stock: 10,
        );

        // Assert
        expect(product.isOnSale, false);
      });
    });

    group('isInStock', () {
      test('should return true when stock > 0', () {
        // Arrange
        final product = Product(
          id: 1,
          title: 'Test',
          description: 'Test',
          price: 100.0,
          discountPercentage: 0.0,
          rating: 4.0,
          brand: 'Test',
          category: 'Test',
          thumbnail: '',
          images: [],
          stock: 5,
        );

        // Assert
        expect(product.isInStock, true);
      });

      test('should return false when stock == 0', () {
        // Arrange
        final product = Product(
          id: 1,
          title: 'Test',
          description: 'Test',
          price: 100.0,
          discountPercentage: 0.0,
          rating: 4.0,
          brand: 'Test',
          category: 'Test',
          thumbnail: '',
          images: [],
          stock: 0,
        );

        // Assert
        expect(product.isInStock, false);
      });
    });
  });
}