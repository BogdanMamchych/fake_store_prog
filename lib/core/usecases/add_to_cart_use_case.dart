import 'package:fake_store_prog/core/models/cart_item.dart';
import 'package:fake_store_prog/core/models/item.dart';
import 'package:fake_store_prog/core/repositories/i_cart_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddToCartUseCase {
  final ICartRepository cartRepository;

  AddToCartUseCase({required this.cartRepository});

  Future<void> call(Item item) async{
    CartItem cartItem = CartItem(itemId: item.id);
    await cartRepository.addItemToCart(cartItem);
  }
}