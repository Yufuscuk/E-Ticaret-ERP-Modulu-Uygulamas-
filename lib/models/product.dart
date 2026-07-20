class Product {
  final int id;
  final String name;
  final String code;
  final double price;
  final int stockQuantity;

  Product({
    required this.id,
    required this.name,
    required this.code,
    required this.price,
    required this.stockQuantity,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      stockQuantity: json['stock_quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'price': price,
      'stock_quantity': stockQuantity,
    };
  }
}
