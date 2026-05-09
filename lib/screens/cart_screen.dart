import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math' as math;
import 'dart:async';
import '../providers/cart_provider.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  StreamSubscription? _accelerometerSubscription;

  @override
  void initState() {
    super.initState();
    _listenToShake();
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  void _listenToShake() {
    _accelerometerSubscription = accelerometerEventStream().listen((event) {
      double acceleration = math.sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      if (acceleration > 18) {
        if (!mounted) return;
        context.read<CartProvider>().clearCart();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cart cleared!')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        backgroundColor: const Color(0xFF6C63FF),
        actions: [
          if (cartProvider.items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () => _showClearDialog(),
            ),
        ],
      ),
      body: cartProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : cartProvider.items.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Your cart is empty'),
          ],
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartProvider.items.length,
              itemBuilder: (context, index) {
                final item = cartProvider.items[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item.thumbnail,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.image),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '\$${item.totalPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6C63FF),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: item.quantity > 1
                                  ? () => cartProvider.updateQuantity(
                                item.productId,
                                item.quantity - 1,
                              )
                                  : null,
                              icon: const Icon(Icons.remove),
                            ),
                            Text(item.quantity.toString()),
                            IconButton(
                              onPressed: () => cartProvider.updateQuantity(
                                item.productId,
                                item.quantity + 1,
                              ),
                              icon: const Icon(Icons.add),
                            ),
                            IconButton(
                              onPressed: () => cartProvider.removeFromCart(
                                item.productId,
                              ),
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(12),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Subtotal'),
                    Text('\$${cartProvider.subtotal.toStringAsFixed(2)}'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Tax (10%)'),
                    Text('\$${cartProvider.tax.toStringAsFixed(2)}'),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '\$${cartProvider.total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF6C63FF),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CheckoutScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Proceed to Checkout'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showClearDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text('Remove all items from cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<CartProvider>().clearCart();
              Navigator.pop(context);
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}