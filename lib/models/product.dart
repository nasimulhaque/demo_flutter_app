class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final double discountPercentage;
  final double rating;
  final String brand;
  final String category;
  final String thumbnail;
  final List<String> images;
  final int stock;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.brand,
    required this.category,
    required this.thumbnail,
    required this.images,
    required this.stock,
  });

  double get discountedPrice {
    return price - (price * discountPercentage / 100);
  }

  bool get isOnSale => discountPercentage > 0;

  bool get isInStock => stock > 0;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      discountPercentage: (json['discountPercentage'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      brand: json['brand'] ?? 'Unknown',
      category: json['category'],
      thumbnail: json['thumbnail'],
      images: List<String>.from(json['images']),
      stock: json['stock'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'discountPercentage': discountPercentage,
      'rating': rating,
      'brand': brand,
      'category': category,
      'thumbnail': thumbnail,
      'images': images,
      'stock': stock,
    };
  }
}