// lib/pages/product_page.dart
import 'package:fake_store_prog/features/product_viewer/bloc/product_viewer_bloc.dart';
import 'package:fake_store_prog/features/product_viewer/bloc/product_viewer_event.dart';
import 'package:fake_store_prog/features/product_viewer/bloc/product_viewer_state.dart';
import 'package:fake_store_prog/features/product_viewer/widgets/bottom_bar.dart';
import 'package:fake_store_prog/features/product_viewer/widgets/header.dart';
import 'package:fake_store_prog/features/product_viewer/widgets/info_card.dart';
import 'package:fake_store_prog/features/product_viewer/widgets/product_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductPage extends StatelessWidget {
  final int productId;
  const ProductPage({Key? key, required this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final backgroundColor = const Color(0xFFF8F7FA);

    return BlocListener<ProductViewerBloc, ProductViewerState>(
      listener: (context, state) {
        if (state is ProductViewerError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: BlocBuilder<ProductViewerBloc, ProductViewerState>(
            builder: (context, state) {
      
              if (state is ProductViewerLoading) {
                return const Center(child: CircularProgressIndicator());
              }
      
              if (state is ProductViewerLoaded) {
                final p = state.productData;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Header(
                      onBack: () => Navigator.pop(context),
                      onToggleFav: () {
                      },
                      isFavorite: false,
                    ),
      
                    ProductImage(imageUrl: p.imageURL),
      
                    InfoCard(product: p),
      
                    BottomBar(
                      price: p.price,
                      onAddToCart: () {
                        context.read<ProductViewerBloc>().add(AddToCart(product: p));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Додано в корзину')),
                        );
                      },
                    ),
                  ],
                );
              }
      
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
