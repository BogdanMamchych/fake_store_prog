import 'package:fake_store_prog/core/local/app_constants.dart';
import 'package:fake_store_prog/core/models/user.dart';
import 'package:fake_store_prog/core/models/item.dart';

abstract class IItemListRepository {
  Future<List<Item>> fetchProductList({int page = 1, int limit = AppConstants.itemsPerPage});
  Future<User> getCurrentUser();
}