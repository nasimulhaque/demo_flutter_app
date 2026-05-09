import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../utils/validators.dart';
import '../services/notification_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _phoneController = TextEditingController();
  final _couponController = TextEditingController();

  String _paymentMethod = 'Credit Card';
  double _discountedTotal = 0;
  String? _couponError;

  @override
  void initState() {
    super.initState();
    _discountedTotal = context.read<CartProvider>().total;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _phoneController.dispose();
    _couponController.dispose();
    super.dispose();
  }

  void _applyCoupon() {
    final coupon = _couponController.text;
    final total = context.read<CartProvider>().total;

    if (coupon.isEmpty) {
      setState(() {
        _discountedTotal = total;
        _couponError = null;
      });
      return;
    }

    final error = Validators.validateCoupon(coupon);
    if (error != null) {
      setState(() {
        _couponError = error;
        _discountedTotal = total;
      });
    } else {
      setState(() {
        _discountedTotal = Validators.applyCoupon(coupon, total);
        _couponError = null;
      });
    }
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    final orderId = 'ORD${DateTime.now().millisecondsSinceEpoch}';

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    await Future.delayed(const Duration(seconds: 2));

    // Clear cart
    await context.read<CartProvider>().clearCart();

    // Show notification
    await NotificationService.showOrderConfirmation(orderId);

    if (context.mounted) {
      Navigator.pop(context); // Close loading
      Navigator.popUntil(context, (route) => route.isFirst);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order #$orderId placed successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: const Color(0xFF6C63FF),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Shipping Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: Validators.validateName,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: Validators.validateAddress,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cityController,
                      decoration: const InputDecoration(
                        labelText: 'City',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                      ),
                      validator: Validators.validatePhone,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Payment Method',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Column(
                children: [
                  RadioListTile(
                    title: const Text('Credit Card'),
                    value: 'Credit Card',
                    // ignore: deprecated_member_use
                    groupValue: _paymentMethod,
                    // ignore: deprecated_member_use
                    onChanged: (value) {
                      setState(() {
                        _paymentMethod = value.toString();
                      });
                    },
                  ),
                  RadioListTile(
                    title: const Text('Cash on Delivery'),
                    value: 'Cash on Delivery',
                    // ignore: deprecated_member_use
                    groupValue: _paymentMethod,
                    // ignore: deprecated_member_use
                    onChanged: (value) {
                      setState(() {
                        _paymentMethod = value.toString();
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Coupon Code',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _couponController,
                      decoration: InputDecoration(
                        hintText: 'Enter coupon (SAVE10, WELCOME20)',
                        border: const OutlineInputBorder(),
                        errorText: _couponError,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _applyCoupon,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                    ),
                    child: const Text('Apply'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
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
                    if (_discountedTotal != cartProvider.total) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Discount',
                            style: TextStyle(color: Colors.green),
                          ),
                          Text(
                            '- \$${(cartProvider.total - _discountedTotal).toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.green),
                          ),
                        ],
                      ),
                    ],
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
                          '\$${_discountedTotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFF6C63FF),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _placeOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Place Order',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}