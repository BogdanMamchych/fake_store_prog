import 'package:fake_store_prog/core/models/user.dart';
import 'package:fake_store_prog/features/product_list/domain/repositories/i_product_list_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetUserUseCase {
  final IProductListRepository repository;
  GetUserUseCase(this.repository);

  Future<User> call() async {
    return repository.getCurrentUser();
  }
}
