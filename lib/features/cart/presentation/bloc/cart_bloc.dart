import 'package:fake_store_prog/features/cart/domain/usecases/confirm_cart_use_case.dart';
import 'package:fake_store_prog/features/cart/domain/usecases/decrease_quantity_use_case.dart';
import 'package:fake_store_prog/features/cart/domain/usecases/fetch_items_use_case.dart';
import 'package:fake_store_prog/features/cart/domain/usecases/get_cart_list_use_case.dart';
import 'package:fake_store_prog/features/cart/domain/usecases/get_total_price_use_case.dart';
import 'package:fake_store_prog/features/cart/domain/usecases/increase_quantity_use_case.dart';
import 'package:fake_store_prog/features/cart/domain/usecases/remove_item_use_case.dart';
import 'package:fake_store_prog/features/cart/presentation/bloc/cart_event.dart';
import 'package:fake_store_prog/features/cart/presentation/bloc/cart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:fake_store_prog/core/models/cart_item.dart';
import 'package:fake_store_prog/core/models/item.dart';
import 'package:fake_store_prog/core/local/exceptions.dart';

@injectable
class CartBloc extends Bloc<CartEvent, CartState> {
  final DecreaseQuantityUseCase _decreaseQuantityUseCase;
  final FetchItemsUseCase _fetchItemsUseCase;
  final GetCartListUseCase _getCartListUseCase;
  final GetTotalPriceUseCase _getTotalPriceUseCase;
  final IncreaseQuantityUseCase _increaseQuantityUseCase;
  final RemoveItemUseCase _removeItemUseCase;
  final ConfirmCartUseCase _confirmCartUseCase;

  CartBloc({
    required DecreaseQuantityUseCase decreaseQuantityUseCase,
    required FetchItemsUseCase fetchItemsUseCase,
    required GetCartListUseCase getCartListUseCase,
    required GetTotalPriceUseCase getTotalPriceUseCase,
    required IncreaseQuantityUseCase increaseQuantityUseCase,
    required RemoveItemUseCase removeItemUseCase,
    required ConfirmCartUseCase confirmCartUseCase,
  })  : _decreaseQuantityUseCase = decreaseQuantityUseCase,
        _fetchItemsUseCase = fetchItemsUseCase,
        _getCartListUseCase = getCartListUseCase,
        _getTotalPriceUseCase = getTotalPriceUseCase,
        _increaseQuantityUseCase = increaseQuantityUseCase,
        _removeItemUseCase = removeItemUseCase,
        _confirmCartUseCase = confirmCartUseCase,
        super(CartInitial()) {
    on<FetchCartRequested>(_onFetchCart);
    on<RemoveItemFromCartRequested>(_onRemoveItem);
    on<IncreaseItemQuantityRequested>(_onIncreaseItemQuantity);
    on<DecreaseItemQuantityRequested>(_onDecreaseItemQuantity);
    on<ConfirmCartRequested>(_confirmCart);
    on<ClearCartRequested>(_onClearCart);
  }

  double _calculateTotal(List<CartItem> cartItems, List<Item> products) {
    final Map<int, Item> productById = {for (var p in products) p.id: p};
    double total = 0.0;
    for (final ci in cartItems) {
      final prod = productById[ci.itemId];
      if (prod != null) total += prod.price * ci.quantity;
    }
    return total;
  }

  List<CartItem> _updateCartItemQuantity(List<CartItem> cartItems, int productId, int delta) {
    return cartItems.map((ci) {
      if (ci.itemId != productId) return ci;
      final newQty = (ci.quantity + delta);
      return ci.copyWith(quantity: newQty);
    }).where((ci) => ci.quantity > 0).toList();
  }

  Future<void> _onFetchCart(
    FetchCartRequested event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoading());
    try {
      final cartItems = await _getCartListUseCase();
      if (cartItems.isEmpty) {
        emit(CartIsEmpty());
        return;
      }
      final items = await _fetchItemsUseCase();
      final totalPrice = await _getTotalPriceUseCase(cartItems: cartItems, items: items);
      emit(CartLoaded(cartItems: cartItems, items: items, totalPrice: totalPrice));
    } on UnauthorizedException catch (ex) {
      emit(CartError(message: ex.message));
    } on InvalidCredentialsException catch (ex) {
      emit(CartError(message: ex.message));
    } on NetworkException catch (ex) {
      emit(CartError(message: ex.message));
    } on TimeoutException catch (ex) {
      emit(CartError(message: ex.message));
    } on ServerException catch (ex) {
      emit(CartError(message: 'Server error: ${ex.statusCode ?? 'unknown'} ${ex.message}'));
    } on ParsingException catch (ex) {
      emit(CartError(message: ex.message));
    } on StorageException catch (ex) {
      emit(CartError(message: ex.message));
    } on NotFoundException catch (ex) {
      emit(CartError(message: ex.message));
    } on ItemNotFoundException catch (ex) {
      emit(CartError(message: ex.message));
    } catch (e) {
      emit(CartError(message: 'Unexpected error. Please try again.'));
    }
  }

  Future<void> _onRemoveItem(
    RemoveItemFromCartRequested event,
    Emitter<CartState> emit,
  ) async {
    final current = state;
    if (current is! CartLoaded) return;

    final prev = current;
    final productId = event.cartItem.itemId;

    final updatedCartItems = prev.cartItems.where((ci) => ci.itemId != productId).toList();
    final updatedItems = prev.items.where((it) => it.id != productId).toList();
    final updatedTotal = _calculateTotal(updatedCartItems, updatedItems);
    final newSyncing = Set<int>.from(prev.syncingItemIds)..add(productId);

    emit(prev.copyWith(
      cartItems: updatedCartItems,
      items: updatedItems,
      totalPrice: updatedTotal,
      syncingItemIds: newSyncing,
    ));

    try {
      await _removeItemUseCase(event.cartItem);
      final afterSync = Set<int>.from(newSyncing)..remove(productId);
      emit(prev.copyWith(
        cartItems: updatedCartItems,
        items: updatedItems,
        totalPrice: updatedTotal,
        syncingItemIds: afterSync,
      ));

      if (updatedCartItems.isEmpty) emit(CartIsEmpty());
    } on UnauthorizedException catch (ex) {
      emit(prev);
      emit(CartError(message: ex.message));
    } on InvalidCredentialsException catch (ex) {
      emit(prev);
      emit(CartError(message: ex.message));
    } on NetworkException catch (ex) {
      emit(prev);
      emit(CartError(message: ex.message));
    } on TimeoutException catch (ex) {
      emit(prev);
      emit(CartError(message: ex.message));
    } on ServerException catch (ex) {
      emit(prev);
      emit(CartError(message: 'Server error: ${ex.statusCode ?? 'unknown'} ${ex.message}'));
    } on StorageException catch (ex) {
      emit(prev);
      emit(CartError(message: ex.message));
    } on ItemNotFoundException catch (ex) {
      emit(prev);
      emit(CartError(message: ex.message));
    } catch (e) {
      emit(prev);
      emit(CartError(message: 'Unexpected error. Please try again.'));
    }
  }

  Future<void> _onIncreaseItemQuantity(
    IncreaseItemQuantityRequested event,
    Emitter<CartState> emit,
  ) async {
    final current = state;
    if (current is! CartLoaded) return;

    final prev = current;
    final productId = event.cartItem.itemId;

    final updatedCartItems = _updateCartItemQuantity(prev.cartItems, productId, 1);
    final updatedTotal = _calculateTotal(updatedCartItems, prev.items);
    final newSyncing = Set<int>.from(prev.syncingItemIds)..add(productId);

    emit(prev.copyWith(
      cartItems: updatedCartItems,
      totalPrice: updatedTotal,
      syncingItemIds: newSyncing,
    ));

    try {
      await _increaseQuantityUseCase(event.cartItem);
      final afterSync = Set<int>.from(newSyncing)..remove(productId);
      emit(prev.copyWith(
        cartItems: updatedCartItems,
        totalPrice: updatedTotal,
        syncingItemIds: afterSync,
      ));
    } on UnauthorizedException catch (ex) {
      emit(prev);
      emit(CartError(message: ex.message));
    } on InvalidCredentialsException catch (ex) {
      emit(prev);
      emit(CartError(message: ex.message));
    } on NetworkException catch (ex) {
      emit(prev);
      emit(CartError(message: ex.message));
    } on TimeoutException catch (ex) {
      emit(prev);
      emit(CartError(message: ex.message));
    } on ServerException catch (ex) {
      emit(prev);
      emit(CartError(message: 'Server error: ${ex.statusCode ?? 'unknown'} ${ex.message}'));
    } on StorageException catch (ex) {
      emit(prev);
      emit(CartError(message: ex.message));
    } on ItemNotFoundException catch (ex) {
      emit(prev);
      emit(CartError(message: ex.message));
    } catch (e) {
      emit(prev);
      emit(CartError(message: 'Unexpected error. Please try again.'));
    }
  }

  Future<void> _onDecreaseItemQuantity(
    DecreaseItemQuantityRequested event,
    Emitter<CartState> emit,
  ) async {
    final current = state;
    if (current is! CartLoaded) return;

    final prev = current;
    final productId = event.cartItem.itemId;

    final delta = -1;
    final updatedCartItems = _updateCartItemQuantity(prev.cartItems, productId, delta);
    final updatedTotal = _calculateTotal(updatedCartItems, prev.items);
    final newSyncing = Set<int>.from(prev.syncingItemIds)..add(productId);

    emit(prev.copyWith(
      cartItems: updatedCartItems,
      totalPrice: updatedTotal,
      syncingItemIds: newSyncing,
    ));

    try {
      await _decreaseQuantityUseCase(event.cartItem);
      final afterSync = Set<int>.from(newSyncing)..remove(productId);
      emit(prev.copyWith(
        cartItems: updatedCartItems,
        totalPrice: updatedTotal,
        syncingItemIds: afterSync,
      ));
      if (updatedCartItems.isEmpty) emit(CartIsEmpty());
    } on UnauthorizedException catch (ex) {
      emit(prev);
      emit(CartError(message: ex.message));
    } on InvalidCredentialsException catch (ex) {
      emit(prev);
      emit(CartError(message: ex.message));
    } on NetworkException catch (ex) {
      emit(prev);
      emit(CartError(message: ex.message));
    } on TimeoutException catch (ex) {
      emit(prev);
      emit(CartError(message: ex.message));
    } on ServerException catch (ex) {
      emit(prev);
      emit(CartError(message: 'Server error: ${ex.statusCode ?? 'unknown'} ${ex.message}'));
    } on StorageException catch (ex) {
      emit(prev);
      emit(CartError(message: ex.message));
    } on ItemNotFoundException catch (ex) {
      emit(prev);
      emit(CartError(message: ex.message));
    } catch (e) {
      emit(prev);
      emit(CartError(message: 'Unexpected error. Please try again.'));
    }
  }

  Future<void> _confirmCart(
    ConfirmCartRequested event,
    Emitter<CartState> emit,
  ) async {
    final current = state;

    if (current is CartLoaded) {
      emit(current.copyWith(isConfirming: true));
    } else {
      emit(CartLoading());
    }

    try {
      await _confirmCartUseCase(event.cartItemList);
      emit(CartIsEmpty());
    } on UnauthorizedException catch (ex) {
      if (current is CartLoaded) {
        emit(current.copyWith(isConfirming: false));
      } else {
        emit(CartError(message: ex.message));
      }
      emit(CartError(message: ex.message));
    } on InvalidCredentialsException catch (ex) {
      if (current is CartLoaded) {
        emit(current.copyWith(isConfirming: false));
      } else {
        emit(CartError(message: ex.message));
      }
      emit(CartError(message: ex.message));
    } on NetworkException catch (ex) {
      if (current is CartLoaded) {
        emit(current.copyWith(isConfirming: false));
      } else {
        emit(CartError(message: ex.message));
      }
      emit(CartError(message: ex.message));
    } on TimeoutException catch (ex) {
      if (current is CartLoaded) {
        emit(current.copyWith(isConfirming: false));
      } else {
        emit(CartError(message: ex.message));
      }
      emit(CartError(message: ex.message));
    } on ServerException catch (ex) {
      final msg = 'Server error: ${ex.statusCode ?? 'unknown'} ${ex.message}';
      if (current is CartLoaded) {
        emit(current.copyWith(isConfirming: false));
      } else {
        emit(CartError(message: msg));
      }
      emit(CartError(message: msg));
    } on StorageException catch (ex) {
      if (current is CartLoaded) {
        emit(current.copyWith(isConfirming: false));
      } else {
        emit(CartError(message: ex.message));
      }
      emit(CartError(message: ex.message));
    } catch (e) {
      if (current is CartLoaded) {
        emit(current.copyWith(isConfirming: false));
      } else {
        emit(CartError(message: 'Unexpected error. Please try again.'));
      }
      emit(CartError(message: 'Unexpected error. Please try again.'));
    }
  }

  Future<void> _onClearCart(
    ClearCartRequested event,
    Emitter<CartState> emit,
  ) async {
    final current = state;
    if (current is! CartLoaded) return;
    final prev = current;

    emit(CartIsEmpty());

    try {
      for (final ci in prev.cartItems) {
        await _removeItemUseCase(ci);
      }
    } on UnauthorizedException catch (ex) {
      emit(prev);
      emit(CartError(message: ex.message));
    } on InvalidCredentialsException catch (ex) {
      emit(prev);
      emit(CartError(message: ex.message));
    } on NetworkException catch (ex) {
      emit(prev);
      emit(CartError(message: ex.message));
    } on TimeoutException catch (ex) {
      emit(prev);
      emit(CartError(message: ex.message));
    } on ServerException catch (ex) {
      emit(prev);
      emit(CartError(message: 'Server error: ${ex.statusCode ?? 'unknown'} ${ex.message}'));
    } on StorageException catch (ex) {
      emit(prev);
      emit(CartError(message: ex.message));
    } on ItemNotFoundException catch (ex) {
      emit(prev);
      emit(CartError(message: ex.message));
    } catch (e) {
      emit(prev);
      emit(CartError(message: 'Unexpected error. Please try again.'));
    }
  }
}
