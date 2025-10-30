import 'package:fake_store_prog/core/widgets/bottom_navigation_bar.dart';
import 'package:fake_store_prog/features/product_list/presentation/bloc/product_list_bloc.dart';
import 'package:fake_store_prog/features/product_list/presentation/bloc/product_list_state.dart';
import 'package:fake_store_prog/core/widgets/header.dart';
import 'package:fake_store_prog/features/product_list/widgets/product_card.dart';
import 'package:fake_store_prog/core/styles/text_styles.dart';
import 'package:flutter/material.dart' hide BottomNavigationBar;
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductListBloc, ProductListState>(
      listener: (context, state) {
        if (state is FetchProductsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        bottomNavigationBar: const BottomNavBar(),
        body: SafeArea(
          child: BlocBuilder<ProductListBloc, ProductListState>(
            builder: (context, state) {
              if (state is FetchLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is OpenProductListSuccess) {
                final username = state.user.name;
                final products = state.products;

                return Column(
                  children: [
                    SizedBox(
                      height: 148,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Header(headerText: "Welcome", username: username),
                      ),
                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Fake Store', style: mainTextStyle),

                            Expanded(
                              child: Builder(
                                builder: (_) {
                                  if (products.isEmpty) {
                                    return Center(
                                      child: Text(
                                        'No products available',
                                        style: mainTextStyle,
                                      ),
                                    );
                                  }
                                  return ListView.separated(
                                    padding: const EdgeInsets.only(
                                      top: 20,
                                      bottom: 16,
                                    ),
                                    itemCount: products.length,
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(height: 12),
                                    itemBuilder: (context, index) =>
                                        ProductCard(
                                          product: products[index],
                                        ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
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
