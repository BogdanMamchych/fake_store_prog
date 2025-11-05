import 'package:fake_store_prog/core/models/item.dart';
import 'package:fake_store_prog/core/usecases/add_to_cart_use_case.dart';
import 'package:fake_store_prog/features/item_viewer/presentation/bloc/item_viewer_bloc.dart';
import 'package:fake_store_prog/features/item_viewer/presentation/bloc/item_viewer_state.dart';
import 'package:fake_store_prog/features/item_viewer/widgets/bottom_bar.dart';
import 'package:fake_store_prog/features/item_viewer/widgets/header.dart';
import 'package:fake_store_prog/features/item_viewer/widgets/info_card.dart';
import 'package:fake_store_prog/features/item_viewer/widgets/product_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fake_store_prog/core/di/injection.dart';
import 'package:go_router/go_router.dart';


class ItemPage extends StatelessWidget {
  final Item item;
  const ItemPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = const Color(0xFFF8F7FA);

    return BlocListener<ItemViewerBloc, ItemViewerState>(
      listener: (context, state) {
        if (state is ItemViewerError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 56),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Header(onBack: () => context.pop(), isFavorite: false),

                ItemImage(imageUrl: item.imageURL),

                InfoCard(item: item),

                BottomBar(
                  price: item.price,
                  onAddToCart: () async {
                    try {
                      final addToCart = getIt<AddToCartUseCase>();
                      await addToCart(item);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Item added to cart')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Error: $e')));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
