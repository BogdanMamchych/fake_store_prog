import 'package:fake_store_prog/core/models/item.dart';
import 'package:fake_store_prog/core/models/cart_item.dart';

abstract class ICartRepository {
  Future<void> addItemToCart(CartItem cartItem);
  Future<void> removeItemFromCart(CartItem item);
  Future<void> increaseItemQuantity(CartItem item);
  Future<void> decreaseItemQuantity(CartItem item);
  Future<List<CartItem>> getCartItems();
  Future<List<Item>> getItemsForCartItems(List<CartItem> items);
  Future<void> confirm(Map<String, dynamic> cartData);
}