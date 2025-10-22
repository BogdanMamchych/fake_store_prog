// lib/pages/product_page.dart
import 'package:fake_store_prog/features/product_viewer/bloc/product_viewer_bloc.dart';
import 'package:fake_store_prog/features/product_viewer/bloc/product_viewer_event.dart';
import 'package:fake_store_prog/features/product_viewer/bloc/product_viewer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fake_store_prog/features/product_list/models/product.dart';

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

                    GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: Container(
                      width: 41,
                      height: 41,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(),
                      ),
                      child: const Center(
                        child: Icon(Icons.arrow_back_ios_new, size: 16),
                      ),
                    ),
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

class Header extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onToggleFav;
  final bool isFavorite;

  const Header({
    Key? key,
    required this.onBack,
    required this.onToggleFav,
    required this.isFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: onBack,
          ),
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: const Color(0xFF3A3A3A),
            ),
            onPressed: onToggleFav,
          ),
        ],
      ),
    );
  }
}

class ProductImage extends StatelessWidget {
  final String imageUrl;
  const ProductImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Використовуємо Expanded, щоб картинка займала простір як в макеті
    return Expanded(
      child: Center(
        child: Container(
          width: 267,
          height: 204,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imageUrl),
              fit: BoxFit.contain,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                offset: const Offset(0, 7),
                blurRadius: 7,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final Product product;
  const InfoCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              product.title,
              style: const TextStyle(
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w600,
                fontSize: 24,
                color: Color.fromRGBO(0, 0, 0, 0.75),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              product.category,
              style: const TextStyle(
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color.fromRGBO(0, 0, 0, 0.5),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.star, size: 14, color: Colors.black),
                const SizedBox(width: 6),
                Text(
                  product.rating.toStringAsFixed(2),
                  style: const TextStyle(
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF303539),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${product.ratingCount} Reviews',
                  style: const TextStyle(
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFFA6A6AA),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BottomBar extends StatelessWidget {
  final double price;
  final VoidCallback onAddToCart;

  const BottomBar({Key? key, required this.price, required this.onAddToCart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottomColor = const Color(0xFFFFE8B2);
    final priceTextStyle = const TextStyle(
      fontFamily: 'Lora',
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Color(0xFF3A3A3A),
    );

    return Container(
      color: bottomColor,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          // Price
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Price',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF616161),
                ),
              ),
              const SizedBox(height: 6),
              Text('\$${price.toStringAsFixed(2)}', style: priceTextStyle),
            ],
          ),
          const Spacer(),

          // Add to cart button
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: onAddToCart,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E1E1E),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                padding: const EdgeInsets.symmetric(horizontal: 24),
              ),
              child: const Text(
                'Add to cart',
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
