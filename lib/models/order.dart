import 'cart.dart';

class Order {
  final String id;
  final List<CartItem> items;
  final double total;
  final DateTime orderDate;
  final String address;
  final String paymentMethod;
  final String status;

  Order({
    required this.id,
    required this.items,
    required this.total,
    required this.orderDate,
    required this.address,
    required this.paymentMethod,
    this.status = 'Pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'items': items.map((item) => item.toMap()).toList(),
      'total': total,
      'orderDate': orderDate.toIso8601String(),
      'address': address,
      'paymentMethod': paymentMethod,
      'status': status,
    };
  }
}