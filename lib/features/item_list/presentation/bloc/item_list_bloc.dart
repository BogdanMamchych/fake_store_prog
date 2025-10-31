import 'package:fake_store_prog/features/item_list/domain/usecases/fetch_products_use_case.dart';
import 'package:fake_store_prog/features/item_list/domain/usecases/get_user_use_case.dart';
import 'package:fake_store_prog/features/item_list/presentation/bloc/item_list_event.dart';
import 'package:fake_store_prog/features/item_list/presentation/bloc/item_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ItemListBloc extends Bloc<ItemListEvent, ItemListState> {
  final FetchItemsUseCase _fetchItemsUseCase;
  final GetUserUseCase _getUserUseCase;

  ItemListBloc({
    required FetchItemsUseCase fetchProductsUseCase,
    required GetUserUseCase getUserUseCase,
  }) : _fetchItemsUseCase = fetchProductsUseCase,
       _getUserUseCase = getUserUseCase,
       super(ProductListStateInitial()) {
    on<FetchProductsEvent>(_onProductEvent);
  }

  Future<void> _onProductEvent(
    FetchProductsEvent event,
    Emitter<ItemListState> emit,
  ) async {
    await _onFetchProducts(event, emit);
  }

  Future<void> _onFetchProducts(
    FetchProductsEvent event,
    Emitter<ItemListState> emit,
  ) async {
    try {
      emit(FetchLoading());
      final products = await _fetchItemsUseCase();
      final user = await _getUserUseCase();
      emit(OpenProductListSuccess(items: products, user: user));
    } catch (e) {
      emit(FetchProductsError(e.toString()));
    }
  }
}
