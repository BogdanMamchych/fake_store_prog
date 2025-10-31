import 'package:fake_store_prog/core/models/cart_item.dart';

(CartItem? item, bool found) findCartItem(List<CartItem> list, CartItem item) {
  for (var ci in list) {
    if (ci.itemId == item.itemId) {
      return (ci, true);
    }
  }
  return (null, false);
}