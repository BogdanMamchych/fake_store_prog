import 'package:fake_store_prog/core/models/cart_item.dart';
import 'package:fake_store_prog/core/repositories/i_cart_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCartListUseCase {
  final ICartRepository cartRepository;

  GetCartListUseCase({required this.cartRepository});


  Future<List<CartItem>> call() => cartRepository.getCartItems();
}
