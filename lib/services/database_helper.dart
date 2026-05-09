import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../models/cart.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('ecommerce.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final path = join(documentsDir.path, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Cart table
    await db.execute('''
      CREATE TABLE cart(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER NOT NULL UNIQUE,
        title TEXT NOT NULL,
        price REAL NOT NULL,
        thumbnail TEXT,
        quantity INTEGER DEFAULT 1
      )
    ''');

    // Favorites table
    await db.execute('''
      CREATE TABLE favorites(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER NOT NULL UNIQUE,
        title TEXT NOT NULL,
        price REAL NOT NULL,
        thumbnail TEXT,
        discount_percentage REAL DEFAULT 0
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE favorites ADD COLUMN discount_percentage REAL DEFAULT 0');
    }
  }

  // ========== CART OPERATIONS ==========
  Future<List<CartItem>> getCartItems() async {
    final db = await instance.database;
    final result = await db.query('cart');
    return result.map((map) => CartItem.fromMap(map)).toList();
  }

  Future<void> addToCart(CartItem item) async {
    final db = await instance.database;
    final existing = await db.query(
      'cart',
      where: 'product_id = ?',
      whereArgs: [item.productId],
    );

    if (existing.isNotEmpty) {
      final newQuantity = (existing.first['quantity'] as int) + item.quantity;
      await db.update(
        'cart',
        {'quantity': newQuantity},
        where: 'product_id = ?',
        whereArgs: [item.productId],
      );
    } else {
      await db.insert('cart', item.toMap());
    }
  }

  Future<void> updateCartQuantity(int productId, int quantity) async {
    final db = await instance.database;
    if (quantity <= 0) {
      await db.delete(
        'cart',
        where: 'product_id = ?',
        whereArgs: [productId],
      );
    } else {
      await db.update(
        'cart',
        {'quantity': quantity},
        where: 'product_id = ?',
        whereArgs: [productId],
      );
    }
  }

  Future<void> removeFromCart(int productId) async {
    final db = await instance.database;
    await db.delete(
      'cart',
      where: 'product_id = ?',
      whereArgs: [productId],
    );
  }

  Future<void> clearCart() async {
    final db = await instance.database;
    await db.delete('cart');
  }

  // ========== FAVORITES OPERATIONS ==========
  Future<List<Map<String, dynamic>>> getFavorites() async {
    final db = await instance.database;
    return await db.query('favorites');
  }

  Future<void> addFavorite(Map<String, dynamic> product) async {
    final db = await instance.database;
    await db.insert(
      'favorites',
      {
        'product_id': product['id'],
        'title': product['title'],
        'price': product['price'],
        'thumbnail': product['thumbnail'],
        'discount_percentage': product['discountPercentage'] ?? 0,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> removeFavorite(int productId) async {
    final db = await instance.database;
    await db.delete(
      'favorites',
      where: 'product_id = ?',
      whereArgs: [productId],
    );
  }

  Future<bool> isFavorite(int productId) async {
    final db = await instance.database;
    final result = await db.query(
      'favorites',
      where: 'product_id = ?',
      whereArgs: [productId],
    );
    return result.isNotEmpty;
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}