import 'package:fake_store_prog/core/models/item.dart';
import 'package:fake_store_prog/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:fake_store_prog/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:fake_store_prog/core/models/cart_item.dart';
import 'package:fake_store_prog/core/repositories/i_cart_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ICartRepository)
class CartRepository implements ICartRepository {
  final CartLocalDataSource localDataSource;
  final CartRemoteDataSource remoteDataSource;

  CartRepository({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<void> addItemToCart(CartItem cartItem) async {
    await localDataSource.addItem(cartItem);
  }

  @override
  Future<void> confirm(Map<String, dynamic> cartData) async {
    await remoteDataSource.confirmCart(cartData);
  }

  Future<void> clearCartList() async {
    await localDataSource.clearCartList();
  }

  @override
  Future<void> decreaseItemQuantity(CartItem item) async {
    await localDataSource.decreaseQuantity(item);
  }

  @override
  Future<List<CartItem>> getCartItems() async {
    return await localDataSource.getCartList();
  }

  @override
  Future<List<Item>> getProductsForCartItems(List<CartItem> items) async {
    try {
      final futures = items.map((ci) => remoteDataSource.getProductById(ci.productId));
      final products = await Future.wait(futures);
      return products;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> increaseItemQuantity(CartItem item) async {
    await localDataSource.increaseQuantity(item);
  }

  @override
  Future<void> removeItemFromCart(CartItem item) async {
    await localDataSource.removeItem(item);
  }
}
