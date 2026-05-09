class CartItem {
  int? id;
  final int productId;
  final String title;
  final double price;
  final String thumbnail;
  int quantity;

  CartItem({
    this.id,
    required this.productId,
    required this.title,
    required this.price,
    required this.thumbnail,
    this.quantity = 1,
  });

  double get totalPrice => price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId,
      'title': title,
      'price': price,
      'thumbnail': thumbnail,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      productId: map['product_id'],
      title: map['title'],
      price: map['price'],
      thumbnail: map['thumbnail'],
      quantity: map['quantity'],
    );
  }
}