import 'package:fake_store_prog/core/models/user.dart';
import 'package:fake_store_prog/features/product_list/domain/entities/product.dart';

abstract class IProductListRepository {
  Future<List<Product>> fetchProductList();
  Future<User> getUserFromSharedPreferences();
}