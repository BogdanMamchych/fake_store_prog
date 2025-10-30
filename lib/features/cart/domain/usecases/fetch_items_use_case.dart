import 'package:fake_store_prog/core/models/item.dart';
import 'package:fake_store_prog/core/repositories/i_cart_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class FetchItemsUseCase {
  final ICartRepository cartRepository;

  FetchItemsUseCase({required this.cartRepository});

  Future<List<Item>> call() async {
    final cartItems = await cartRepository.getCartItems();
    if (cartItems.isEmpty) return [];

    final items = await cartRepository.getProductsForCartItems(cartItems);
    return items;
  }
}