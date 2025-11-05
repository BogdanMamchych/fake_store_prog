import 'package:fake_store_prog/core/models/cart_item.dart';

class Cart {
  final int id;
  final int userId;
  final DateTime date;
  List<CartItem> items;

  Cart({required this.id, required this.userId, required this.date, required this.items});

  Map<String,dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'date': date.toIso8601String(),
    'products': items.map((p) => p.toJson()).toList(),
  };

  
}
