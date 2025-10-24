import 'package:fake_store_prog/core/local/exceptions.dart';
import 'package:fake_store_prog/core/local/user_preferences.dart';
import 'package:fake_store_prog/core/models/user.dart';
import 'package:fake_store_prog/features/product_list/data/datasources/product_list_remote_data_source.dart';
import 'package:fake_store_prog/features/product_list/domain/entities/product.dart';
import 'package:fake_store_prog/features/product_list/domain/repositories/i_product_list_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IProductListRepository)
class ProductListRepository implements IProductListRepository {
  final ProductListRemoteDataSource remoteDataSource;
  final UserPreferences userPreferences;

  ProductListRepository({
    required this.remoteDataSource,
    required this.userPreferences,
  });

  @override
  Future<List<Product>> fetchProductList() async {
    try {
      return await remoteDataSource.fetchProducts();
    } on NetworkException {
      rethrow;
    } on TimeoutException {
      rethrow;
    } on UnauthorizedException {
      rethrow;
    } on ServerException {
      rethrow;
    } on ParsingException {
      rethrow;
    } on Exception catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<User> getUserFromSharedPreferences() async {
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
