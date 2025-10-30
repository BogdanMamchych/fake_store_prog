import 'package:fake_store_prog/core/repositories/i_cart_repository.dart';
import 'package:fake_store_prog/core/models/cart_item.dart';
import 'package:injectable/injectable.dart';

@injectable
class IncreaseQuantityUseCase {
  final ICartRepository cartRepository;

  IncreaseQuantityUseCase({required this.cartRepository});

  Future<void> call(CartItem item) async {
    await cartRepository.increaseItemQuantity(item);
  }
}