import 'package:fake_store_prog/core/mappers/item_mapper.dart';
import 'package:fake_store_prog/core/models/cart_item.dart';
import 'package:fake_store_prog/core/models/item.dart';
import 'package:fake_store_prog/core/repositories/i_cart_repository.dart';
import 'package:injectable/injectable.dart';


@injectable
class AddItemUseCase {
  final ICartRepository cartRepository;

  AddItemUseCase({required this.cartRepository});

  Future<void> call(Item item) async {
    CartItem cartItem = item.toCartItem();
    await cartRepository.addItemToCart(cartItem);
  }
}