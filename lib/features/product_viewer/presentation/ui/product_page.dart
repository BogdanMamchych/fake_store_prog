import 'package:fake_store_prog/core/models/item.dart';
import 'package:fake_store_prog/core/usecases/add_to_cart_use_case.dart';
import 'package:fake_store_prog/features/product_viewer/presentation/bloc/product_viewer_bloc.dart';
import 'package:fake_store_prog/features/product_viewer/presentation/bloc/product_viewer_state.dart';
import 'package:fake_store_prog/features/product_viewer/widgets/bottom_bar.dart';
import 'package:fake_store_prog/features/product_viewer/widgets/header.dart';
import 'package:fake_store_prog/features/product_viewer/widgets/info_card.dart';
import 'package:fake_store_prog/features/product_viewer/widgets/product_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fake_store_prog/core/di/injection.dart';

class ProductPage extends StatelessWidget {
  final Item item;
  const ProductPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = const Color(0xFFF8F7FA);

    return BlocListener<ProductViewerBloc, ProductViewerState>(
      listener: (context, state) {
        if (state is ProductViewerError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Header(onBack: () => Navigator.pop(context), isFavorite: false),

              ProductImage(imageUrl: item.imageURL),

              InfoCard(product: item),

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
    );
  }
}
