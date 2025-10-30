import 'package:fake_store_prog/core/models/cart_item.dart';

class Cart {
  final int id;
  final int userId;
  final DateTime date;
  List<CartItem> products;

  Cart({required this.id, required this.userId, required this.date, required this.products});

  Map<String,dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'date': date.toIso8601String(),
    'products': products.map((p) => p.toJson()).toList(),
  };

  
}
