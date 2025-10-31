import 'package:fake_store_prog/features/product_viewer/presentation/bloc/product_viewer_event.dart';
import 'package:fake_store_prog/features/product_viewer/presentation/bloc/product_viewer_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:fake_store_prog/features/product_viewer/domain/usecases/add_item_use_case.dart';

@injectable
class ProductViewerBloc extends Bloc<ProductViewerEvent, ProductViewerState> {
  final AddItemUseCase _addItemUseCase;

  ProductViewerBloc({required AddItemUseCase addItemUseCase})
    : _addItemUseCase = addItemUseCase,
      super(ProductViewerInitial()) {
    on<AddToCartEvent>(_onAddToCart);
  }

  Future<void> _onAddToCart(
    AddToCartEvent event,
    Emitter<ProductViewerState> emit,
  ) async {
    try {
      await _addItemUseCase.call(event.product);
    } catch (e) {
      emit(ProductViewerError(message: e.toString()));
    }
  }
}
