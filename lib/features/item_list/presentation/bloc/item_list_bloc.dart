import 'package:fake_store_prog/core/local/app_constants.dart';
import 'package:fake_store_prog/core/models/item.dart';
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

  int _page = 1;
  bool _hasReachedMax = false;
  bool _isFetching = false;

  ItemListBloc({
    required FetchItemsUseCase fetchProductsUseCase,
    required GetUserUseCase getUserUseCase,
  })  : _fetchItemsUseCase = fetchProductsUseCase,
        _getUserUseCase = getUserUseCase,
        super(ProductListStateInitial()) {
    on<FetchItemsEvent>(_onFetchProducts);
  }

  Future<void> _onFetchProducts(
    FetchItemsEvent event,
    Emitter<ItemListState> emit,
  ) async {
    if (_isFetching) return;
    _isFetching = true;

    try {
      if (event.refresh) {
        _page = 1;
        _hasReachedMax = false;
        emit(FetchLoading());
      }

      if (_hasReachedMax && !event.refresh) {
        _isFetching = false;
        return;
      }

      final products = await _fetchItemsUseCase.call(page: _page, limit: AppConstants.itemsPerPage);
      final user = await _getUserUseCase();

      final fetchedCount = products.length;
      final reachedMax = fetchedCount < AppConstants.itemsPerPage;

      if (_page == 1) {
        emit(OpenProductListSuccess(items: products, user: user, hasReachedMax: reachedMax, page: _page));
      } else {
        final current = state;
        if (current is OpenProductListSuccess) {
          final List<Item> combined = List.from(current.items)..addAll(products);
          emit(OpenProductListSuccess(items: combined, user: user, hasReachedMax: reachedMax, page: _page));
        } else {
          emit(OpenProductListSuccess(items: products, user: user, hasReachedMax: reachedMax, page: _page));
        }
      }

      if (!reachedMax) {
        _page += 1;
      } else {
        _hasReachedMax = true;
      }
    } catch (e) {
      emit(FetchProductsError(e.toString()));
    } finally {
      _isFetching = false;
    }
  }
}
