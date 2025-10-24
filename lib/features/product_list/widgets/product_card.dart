import 'package:fake_store_prog/features/product_list/domain/entities/product.dart';
import 'package:fake_store_prog/features/product_viewer/bloc/product_viewer_bloc.dart';
import 'package:fake_store_prog/features/product_viewer/bloc/product_viewer_event.dart';
import 'package:fake_store_prog/features/product_viewer/ui/product_page.dart';
import 'package:fake_store_prog/core/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider<ProductViewerBloc>(
                create: (ctx) => GetIt.I<ProductViewerBloc>()..add(GetProductEvent(productId: product.id)),
                child: ProductPage(productId: product.id),
              ),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          height: 121,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(0, 0, 0, 0.05),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                width: 112,
                height: 121,
                alignment: Alignment.center,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    image: DecorationImage(
                      image: NetworkImage(product.imageURL),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
        
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.title,
                                  style: buttonTextStyle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  product.description,
                                  style: labelTextStyle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
        
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider<ProductViewerBloc>(
                                    create: (ctx) => GetIt.I<ProductViewerBloc>()..add(GetProductEvent(productId: product.id)),
                                    child: ProductPage(productId: product.id),
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.favorite_border),
                            constraints: const BoxConstraints.tightFor(width: 40, height: 40),
                          ),
                        ],
                      ),
        
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.star, size: 10),
                              const SizedBox(width: 4),
                              Text(product.rating.toStringAsFixed(1), style: labelTextStyle),
                            ],
                          ),
                          Text('\$${product.price.toStringAsFixed(2)}', style: labelTextStyle),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
