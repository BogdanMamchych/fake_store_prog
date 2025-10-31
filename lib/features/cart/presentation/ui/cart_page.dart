import 'package:fake_store_prog/core/widgets/bottom_navigation_bar.dart';
import 'package:fake_store_prog/features/cart/widgets/quantity_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fake_store_prog/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:fake_store_prog/features/cart/presentation/bloc/cart_event.dart';
import 'package:fake_store_prog/features/cart/presentation/bloc/cart_state.dart';
import 'package:fake_store_prog/core/widgets/header.dart';
import 'package:fake_store_prog/core/models/cart_item.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartBloc, CartState>(
      listener: (context, state) {},
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 183,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Header(headerText: "Cart"),
                ),
              ),

              Builder(
                builder: (context) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    context.read<CartBloc>().add(FetchCartEvent());
                  });
                  return const SizedBox.shrink();
                },
              ),

              Expanded(
                child: BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) {
                    if (state is CartLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is CartIsEmpty) {
                      return const Center(child: Text('Cart is empty'));
                    } else if (state is CartLoaded) {
                      final items = state.items;
                      final cartItems = state.cartItems;
                      final double totalPrice = state.totalPrice;

                      return Column(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 8),
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                final item = items[index];
                                CartItem? cartItem;
                                try {
                                  cartItem = cartItems.firstWhere(
                                    (c) => c.itemId == item.id,
                                  );
                                } catch (_) {
                                  cartItem = null;
                                }

                                final qty = cartItem?.quantity ?? 1;

                                return Dismissible(
                                  key: ValueKey(item.id),
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                    ),
                                    padding: const EdgeInsets.only(right: 24),
                                    alignment: Alignment.centerRight,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFCC474E),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onDismissed: (_) {
                                    if (cartItem != null) {
                                      context.read<CartBloc>().add(
                                        RemoveItemFromCartEvent(
                                          cartItem: cartItem,
                                        ),
                                      );
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 0,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                          child: SizedBox(
                                            width: 70,
                                            height: 70,
                                            child: Image.network(
                                              item.imageURL,
                                              fit: BoxFit.cover,
                                              errorBuilder: (c, e, s) =>
                                                  Container(
                                                    color: Colors.grey.shade200,
                                                    child: const Icon(
                                                      Icons.image,
                                                      size: 30,
                                                      color: Colors.black26,
                                                    ),
                                                  ),
                                            ),
                                          ),
                                        ),

                                        const SizedBox(width: 16),

                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      item.title,
                                                      style: const TextStyle(
                                                        fontFamily: 'Urbanist',
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(height: 8),
                                                    QuantitySelector(
                                                      value: qty,
                                                      onIncrease: () {
                                                        if (cartItem != null) {
                                                          context
                                                              .read<CartBloc>()
                                                              .add(
                                                                IncreaseItemQuantityEvent(
                                                                  cartItem:
                                                                      cartItem,
                                                                ),
                                                              );
                                                        }
                                                      },
                                                      onDecrease: () {
                                                        if (cartItem != null) {
                                                          context
                                                              .read<CartBloc>()
                                                              .add(
                                                                DecreaseItemQuantityEvent(
                                                                  cartItem:
                                                                      cartItem,
                                                                ),
                                                              );
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              // Price
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 12.0,
                                                ),
                                                child: Text(
                                                  '\$${(item.price).toStringAsFixed(2)}',
                                                  style: const TextStyle(
                                                    fontFamily: 'Urbanist',
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          Container(height: 1, color: Colors.black12),

                          SafeArea(
                            top: false,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24.0,
                                vertical: 12.0,
                              ),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Cart total',
                                        style: TextStyle(
                                          fontFamily: 'urbanist',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF616161),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '\$${totalPrice.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontFamily: 'Urbanist',
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF3A3A3A),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF1E1E1E,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        context.read<CartBloc>().add(
                                          ConfirmCartEvent(
                                            cartItemList: cartItems,
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'Checkout',
                                        style: TextStyle(
                                          fontFamily: 'urbanist',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    return const Center(child: Text('No items'));
                  },
                ),
              ),
              BottomNavBar(),
            ],
          ),
        ),
      ),
    );
  }
}
