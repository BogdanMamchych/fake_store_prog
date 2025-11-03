import 'package:equatable/equatable.dart';
import 'package:fake_store_prog/core/models/cart_item.dart';

abstract class CartEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class FetchCartRequested extends CartEvent {}

class ClearCartRequested extends CartEvent {}

class RemoveItemFromCartRequested extends CartEvent {
  final CartItem cartItem;

  RemoveItemFromCartRequested({required this.cartItem});

  @override
  List<Object?> get props => [cartItem];
}

class IncreaseItemQuantityRequested extends CartEvent {
  final CartItem cartItem;

  IncreaseItemQuantityRequested({required this.cartItem});

  @override
  List<Object?> get props => [cartItem];
}

class DecreaseItemQuantityRequested extends CartEvent {
  final CartItem cartItem;

  DecreaseItemQuantityRequested({required this.cartItem});

  @override
  List<Object?> get props => [cartItem];
}

class ConfirmCartRequested extends CartEvent {
  final List<CartItem> cartItemList;

  ConfirmCartRequested({required this.cartItemList});

  @override
  List<Object?> get props => [cartItemList];
}
