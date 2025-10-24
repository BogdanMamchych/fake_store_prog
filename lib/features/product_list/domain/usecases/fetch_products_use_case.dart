import 'package:fake_store_prog/features/product_list/domain/entities/product.dart';
import 'package:fake_store_prog/features/product_list/domain/repositories/i_product_list_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class FetchProductsUseCase {
  final IProductListRepository repository;
  FetchProductsUseCase(this.repository);

  Future<List<Product>> call () {
    return repository.fetchProductList();
  }
}