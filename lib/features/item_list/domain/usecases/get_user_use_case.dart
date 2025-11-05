import 'package:fake_store_prog/core/models/user.dart';
import 'package:fake_store_prog/features/item_list/domain/repositories/i_item_list_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetUserUseCase {
  final IItemListRepository repository;
  GetUserUseCase(this.repository);

  Future<User> call() async {
    return repository.getCurrentUser();
  }
}
