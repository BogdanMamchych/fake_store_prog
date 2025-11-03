import 'package:fake_store_prog/core/local/app_constants.dart';
import 'package:fake_store_prog/core/models/item.dart';
import 'package:fake_store_prog/features/item_list/domain/repositories/i_product_list_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class FetchItemsUseCase {
  final IProductListRepository repository;
  FetchItemsUseCase(this.repository);

  Future<List<Item>> call({int page = 1, int limit = AppConstants.itemsPerPage}) {
    return repository.fetchProductList(page: page, limit: limit);
  }
}