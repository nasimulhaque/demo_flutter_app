import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../services/database_helper.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];
  bool _isLoading = false;

  List<CartItem> get items => _items;
  bool get isLoading => _isLoading;

  int get itemCount => _items.length;

  double get subtotal {
    return _items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  double get tax => subtotal * 0.10; // 10% tax

  double get total => subtotal + tax;

  CartProvider() {
    loadCart();
  }

  Future<void> loadCart() async {
    _isLoading = true;
    notifyListeners();

    _items = await DatabaseHelper.instance.getCartItems();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addToCart(Product product, {int quantity = 1}) async {
    final existingItem = _items.firstWhere(
          (item) => item.productId == product.id,
      orElse: () => CartItem(
        productId: product.id,
        title: product.title,
        price: product.discountedPrice,
        thumbnail: product.thumbnail,
      ),
    );

    if (_items.contains(existingItem)) {
      await DatabaseHelper.instance.updateCartQuantity(
        product.id,
        existingItem.quantity + quantity,
      );
    } else {
      await DatabaseHelper.instance.addToCart(
        CartItem(
          productId: product.id,
          title: product.title,
          price: product.discountedPrice,
          thumbnail: product.thumbnail,
          quantity: quantity,
        ),
      );
    }

    await loadCart();
  }

  Future<void> updateQuantity(int productId, int quantity) async {
    await DatabaseHelper.instance.updateCartQuantity(productId, quantity);
    await loadCart();
  }

  Future<void> removeFromCart(int productId) async {
    await DatabaseHelper.instance.removeFromCart(productId);
    await loadCart();
  }

  Future<void> clearCart() async {
    await DatabaseHelper.instance.clearCart();
    await loadCart();
  }
}