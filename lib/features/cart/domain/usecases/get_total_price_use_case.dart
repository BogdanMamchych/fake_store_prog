import 'package:fake_store_prog/core/local/exceptions.dart';
import 'package:fake_store_prog/core/models/cart_item.dart';
import 'package:fake_store_prog/core/models/item.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetTotalPriceUseCase {
  Future<double> call({
    required List<CartItem> cartItems,
    required List<Item> items,
  }) async {
    if (cartItems.isEmpty || items.isEmpty) return 0.0;

    final Map<int, Item> itemById = {for (var it in items) it.id: it};

    int totalCents = 0;

    for (final ci in cartItems) {
      final product = itemById[ci.itemId];
      if (product == null) {
        if (product == null) {
          throw ItemNotFoundException('Product ${ci.itemId} not found');
        }
      }

      final price = product.price;

      final cents = (price * 100).round();
      totalCents += cents * ci.quantity;
    }

    return totalCents / 100.0;
  }
}
