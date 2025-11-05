import 'package:fake_store_prog/core/local/app_constants.dart';
import 'package:fake_store_prog/core/local/exceptions.dart';
import 'package:fake_store_prog/core/local/user_preferences.dart';
import 'package:fake_store_prog/core/models/user.dart';
import 'package:fake_store_prog/features/item_list/data/datasources/item_list_remote_data_source.dart';
import 'package:fake_store_prog/core/models/item.dart';
import 'package:fake_store_prog/features/item_list/domain/repositories/i_item_list_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IItemListRepository)
class ItemListRepository implements IItemListRepository {
  final ItemListRemoteDataSource remoteDataSource;
  final UserPreferences userPreferences;

  ItemListRepository({
    required this.remoteDataSource,
    required this.userPreferences,
  });

  @override
  Future<List<Item>> fetchProductList({int page = 1, int limit = AppConstants.itemsPerPage}) async {
    try {
      final all = await remoteDataSource.fetchItems();

      final start = (page - 1) * limit;
      if (start >= all.length) return <Item>[];
      final end = (start + limit) > all.length ? all.length : (start + limit);
      return all.sublist(start, end);
    } on StorageException {
      rethrow;
    } on ParsingException {
      rethrow;
    } on Exception catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<User> getCurrentUser() async {
    try {
      final user = await remoteDataSource.user;
      if (user != null) return user;
      throw NotFoundException('User not found in local storage');
    } on StorageException {
      rethrow;
    } on ParsingException {
      rethrow;
    } on Exception catch (e) {
      throw UnexpectedException(e.toString());
    }
  }
}
