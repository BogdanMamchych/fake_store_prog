class CartItem {
  final int itemId;
  int quantity;

  CartItem({
    required this.itemId,
    this.quantity = 1,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      itemId: json['productId'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': itemId,
      'quantity': quantity,
    };
  }

  CartItem copyWith({
    int? productId,
    int? quantity,
  }) {
    return CartItem(
      itemId: productId ?? this.itemId,
      quantity: quantity ?? this.quantity,
    );
  }
}