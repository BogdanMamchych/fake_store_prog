import 'package:fake_store_prog/core/api/api_client.dart';
import 'package:fake_store_prog/features/product_list/bloc/product_list_event.dart';
import 'package:fake_store_prog/features/product_list/bloc/product_list_state.dart';
import 'package:fake_store_prog/features/product_list/models/product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProductListBloc extends Bloc<ProductListEvent, ProductListState>{
  final ApiClient _apiClient;

  ProductListBloc({required ApiClient apiClient})
      : _apiClient = apiClient,
        super(ProductListStateInitial()) {
    on<FetchProductsEvent>(_onProductEvent);
  }

  Future<void> _onProductEvent(FetchProductsEvent event, Emitter<ProductListState> emit) async {
    await _onFetchProducts(event, emit);
  }

  Future<void> _onFetchProducts(
      FetchProductsEvent event,
      Emitter<ProductListState> emit,
      ) async {
    try {
      emit(FetchLoading());
      final response = await _apiClient.fetchProducts();
      final List<dynamic> data = response.data;
      final products = data.map((json) => Product.fromJson(json)).toList();
      emit(FetchProductsSuccess(products: products));
    } catch (e) {
      emit(FetchProductsError(e.toString()));
    }
  }

}