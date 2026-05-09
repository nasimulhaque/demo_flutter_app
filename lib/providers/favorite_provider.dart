import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import '../models/product.dart';

class FavoriteProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _favorites = [];
  Set<int> _favoriteIds = {};

  List<Map<String, dynamic>> get favorites => _favorites;
  Set<int> get favoriteIds => _favoriteIds;

  FavoriteProvider() {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    _favorites = await DatabaseHelper.instance.getFavorites();
    _favoriteIds = _favorites.map((f) => f['product_id'] as int).toSet();
    notifyListeners();
  }

  Future<void> addFavorite(Product product) async {
    await DatabaseHelper.instance.addFavorite({
      'id': product.id,
      'title': product.title,
      'price': product.discountedPrice,
      'thumbnail': product.thumbnail,
      'discountPercentage': product.discountPercentage,
    });
    await loadFavorites();
  }

  Future<void> removeFavorite(int productId) async {
    await DatabaseHelper.instance.removeFavorite(productId);
    await loadFavorites();
  }

  Future<void> toggleFavorite(Product product) async {
    if (isFavorite(product.id)) {
      await removeFavorite(product.id);
    } else {
      await addFavorite(product);
    }
  }

  bool isFavorite(int productId) {
    return _favoriteIds.contains(productId);
  }
}