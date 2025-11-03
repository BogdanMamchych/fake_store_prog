import 'package:fake_store_prog/features/item_viewer/presentation/bloc/item_viewer_event.dart';
import 'package:fake_store_prog/features/item_viewer/presentation/bloc/item_viewer_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:fake_store_prog/features/item_viewer/domain/usecases/add_item_use_case.dart';

@injectable
class ItemViewerBloc extends Bloc<ItemViewerEvent, ItemViewerState> {
  final AddItemUseCase _addItemUseCase;

  ItemViewerBloc({required AddItemUseCase addItemUseCase})
    : _addItemUseCase = addItemUseCase,
      super(ItemViewerInitial()) {
    on<AddToCartRequested>(_onAddToCart);
  }

  Future<void> _onAddToCart(
    AddToCartRequested event,
    Emitter<ItemViewerState> emit,
  ) async {
    try {
      await _addItemUseCase.call(event.item);
    } catch (e) {
      emit(ItemViewerError(message: e.toString()));
    }
  }
}
