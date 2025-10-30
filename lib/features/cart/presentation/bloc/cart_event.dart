import 'package:equatable/equatable.dart';
import 'package:fake_store_prog/core/models/cart_item.dart';

abstract class CartEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class FetchCartEvent extends CartEvent {}

class ClearCartEvent extends CartEvent {}

class RemoveItemFromCartEvent extends CartEvent {
  final CartItem cartItem;

  RemoveItemFromCartEvent({required this.cartItem});

  @override
  List<Object?> get props => [cartItem];
}

class IncreaseItemQuantityEvent extends CartEvent {
  final CartItem cartItem;

  IncreaseItemQuantityEvent({required this.cartItem});

  @override
  List<Object?> get props => [cartItem];
}

class DecreaseItemQuantityEvent extends CartEvent {
  final CartItem cartItem;

  DecreaseItemQuantityEvent({required this.cartItem});

  @override
  List<Object?> get props => [cartItem];
}

class ConfirmCartEvent extends CartEvent {
  final List<CartItem> cartItemList;

  ConfirmCartEvent({required this.cartItemList});

  @override
  List<Object?> get props => [cartItemList];
}
