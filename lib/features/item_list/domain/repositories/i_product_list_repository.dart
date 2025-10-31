import 'package:fake_store_prog/core/models/user.dart';
import 'package:fake_store_prog/core/models/item.dart';

abstract class IProductListRepository {
  Future<List<Item>> fetchProductList();
  Future<User> getCurrentUser();
}