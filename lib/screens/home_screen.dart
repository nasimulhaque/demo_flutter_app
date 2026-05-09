import 'package:demo_flutter_app/screens/product_grid_screen.dart';
import 'package:flutter/material.dart';
// import '../services/api_service.dart';
// import '../models/product.dart';
import 'cart_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final ApiService _apiService = ApiService();
  // List<Product> _products = [];
  // List<String> _categories = [];
  // String _selectedCategory = 'All';
  // bool _isLoading = true;
  // String? _error;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // _loadData();
  }

  // Future<void> _loadData() async {
  //   setState(() {
  //     _isLoading = true;
  //     _error = null;
  //   });
  //
  //   try {
  //     final products = await _apiService.fetchProducts(limit: 30);
  //     final categories = await _apiService.fetchCategories();
  //     setState(() {
  //       _products = products;
  //       _categories = ['All', ...categories.map((c) => c.name)];
  //       _isLoading = false;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       _error = e.toString();
  //       _isLoading = false;
  //     });
  //   }
  // }
  //
  // Future<void> _filterByCategory(String category) async {
  //   setState(() {
  //     _selectedCategory = category;
  //     _isLoading = true;
  //   });
  //
  //   try {
  //     List<Product> products;
  //     if (category == 'All') {
  //       products = await _apiService.fetchProducts(limit: 30);
  //     } else {
  //       products = await _apiService.fetchProductsByCategory(category);
  //     }
  //     setState(() {
  //       _products = products;
  //       _isLoading = false;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       _error = e.toString();
  //       _isLoading = false;
  //     });
  //   }
  // }

  final List<Widget> _screens = [
    const ProductGridScreen(),
    const FavoritesScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}