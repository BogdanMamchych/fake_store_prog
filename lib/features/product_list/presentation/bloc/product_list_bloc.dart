import 'package:fake_store_prog/features/product_list/domain/usecases/fetch_products_use_case.dart';
import 'package:fake_store_prog/features/product_list/domain/usecases/get_user_use_case.dart';
import 'package:fake_store_prog/features/product_list/presentation/bloc/product_list_event.dart';
import 'package:fake_store_prog/features/product_list/presentation/bloc/product_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final FetchProductsUseCase _fetchProductsUseCase;
  final GetUserUseCase _getUserUseCase;

  ProductListBloc({
    required FetchProductsUseCase fetchProductsUseCase,
    required GetUserUseCase getUserUseCase,
  }) : _fetchProductsUseCase = fetchProductsUseCase,
       _getUserUseCase = getUserUseCase,
       super(ProductListStateInitial()) {
    on<FetchProductsEvent>(_onProductEvent);
  }

  Future<void> _onProductEvent(
    FetchProductsEvent event,
    Emitter<ProductListState> emit,
  ) async {
    await _onFetchProducts(event, emit);
  }

  Future<void> _onFetchProducts(
    FetchProductsEvent event,
    Emitter<ProductListState> emit,
  ) async {
    try {
      emit(FetchLoading());
      final products = await _fetchProductsUseCase();
      final user = await _getUserUseCase();
      emit(OpenProductListSuccess(products: products, user: user));
    } catch (e) {
      emit(FetchProductsError(e.toString()));
    }
  }
}
