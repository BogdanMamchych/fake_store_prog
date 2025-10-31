import 'package:fake_store_prog/core/models/cart_item.dart';
import 'package:fake_store_prog/core/models/item.dart';

extension ItemToCartItem on Item {
  CartItem toCartItem({int quantity = 1}) {
    return CartItem(productId: id, quantity: quantity);
  }
}