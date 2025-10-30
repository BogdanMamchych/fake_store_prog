import 'package:fake_store_prog/core/local/exceptions.dart';
import 'package:fake_store_prog/core/local/user_preferences.dart';
import 'package:fake_store_prog/core/models/cart_item.dart';
import 'package:fake_store_prog/core/repositories/i_cart_repository.dart';
import 'package:fake_store_prog/features/cart/domain/entities/cart.dart';
import 'package:injectable/injectable.dart';

@injectable
class ConfirmCartUseCase {
  final ICartRepository cartRepository;
  final UserPreferences userPreferences;

  ConfirmCartUseCase({
    required this.cartRepository,
    required this.userPreferences,
  });

  Future<void> call(List<CartItem> cartItems) async {
    final user = userPreferences.getUser();
    if (user == null) {
      throw UnauthorizedException('User not authenticated');
    }
    final cart = Cart(
      id: 0,
      userId: user.id,
      date: DateTime.now(),
      products: cartItems,
    );

    Map<String, dynamic> cartData = cart.toJson();
    await cartRepository.confirm(cartData);
  }
}
