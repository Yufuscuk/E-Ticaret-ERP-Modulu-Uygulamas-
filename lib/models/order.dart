import 'cart_item.dart';

class Order {
  final String id;
  final DateTime date;
  final List<CartItem> items;
  final double totalAmount;

  Order({
    required this.id,
    required this.date,
    required this.items,
    required this.totalAmount,
  });
}
