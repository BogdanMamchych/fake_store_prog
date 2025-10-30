import 'package:equatable/equatable.dart';
import 'package:fake_store_prog/core/models/item.dart';
import 'package:fake_store_prog/core/models/cart_item.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartError extends CartState {
  final String message;
  const CartError({required this.message});

  @override
  List<Object?> get props => [message];
}

class CartLoaded extends CartState {
  final List<CartItem> cartItems;
  final List<Item> items;
  final double totalPrice;
  final Set<int> syncingItemIds;
  final bool isConfirming;

  const CartLoaded({
    required this.cartItems,
    required this.items,
    required this.totalPrice,
    this.syncingItemIds = const {},
    this.isConfirming = false,
  });

  CartLoaded copyWith({
    List<CartItem>? cartItems,
    List<Item>? items,
    double? totalPrice,
    Set<int>? syncingItemIds,
    bool? isConfirming,
  }) {
    return CartLoaded(
      cartItems: cartItems ?? this.cartItems,
      items: items ?? this.items,
      totalPrice: totalPrice ?? this.totalPrice,
      syncingItemIds: syncingItemIds ?? this.syncingItemIds,
      isConfirming: isConfirming ?? this.isConfirming,
    );
  }

  @override
  List<Object?> get props => [cartItems, items, totalPrice, syncingItemIds.toList(), isConfirming];
}

class CartIsEmpty extends CartState {}
