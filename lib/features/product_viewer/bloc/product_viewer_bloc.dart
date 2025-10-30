import 'package:fake_store_prog/core/api/api_client.dart';
import 'package:fake_store_prog/core/models/item.dart';
import 'package:fake_store_prog/features/product_viewer/bloc/product_viewer_event.dart';
import 'package:fake_store_prog/features/product_viewer/bloc/product_viewer_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProductViewerBloc extends Bloc<ProductViewerEvent, ProductViewerState> {
  final ApiClient _apiClient;

  ProductViewerBloc({required ApiClient apiClient})
    : _apiClient = apiClient,
      super(ProductViewerInitial()) {
    on<GetProductEvent>(_onLoadProductDetails);
  }

  Future<void> _onLoadProductDetails(
    GetProductEvent event,
    Emitter<ProductViewerState> emit,
  ) async {
    emit(ProductViewerLoading());
    try {
      final response = await _apiClient.getProductById(
        event.productId,
      );
      final Item productData = Item.fromJson(
        response.data as Map<String, dynamic>,
      );
      emit(ProductViewerLoaded(productData: productData));
    } catch (e) {
      emit(ProductViewerError(message: e.toString()));
    }
  }
}
