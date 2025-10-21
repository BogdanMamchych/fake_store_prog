import 'package:fake_store_prog/core/local/user_preferences.dart';
import 'package:fake_store_prog/features/product_list/bloc/product_list_bloc.dart';
import 'package:fake_store_prog/features/product_list/bloc/product_list_state.dart';
import 'package:fake_store_prog/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:fake_store_prog/features/product_list/models/product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userPrefs = GetIt.I<UserPreferences>();
    final user = userPrefs.getUser();
    final username = (user?.name ?? 'User');

    return BlocListener<ProductListBloc, ProductListState>(
      listener: (context, state) {
        if (state is FetchProductsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        bottomNavigationBar: const _BottomNavigationBar(),
        body: SafeArea(
          child: Column(
            children: [
              // Верхній фон
              SizedBox(
                height: 183,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: _Header(username: username),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text('Fake Store', style: mainTextStyle),
                      const SizedBox(height: 16),

                      Expanded(
                        child: BlocBuilder<ProductListBloc, ProductListState>(
                          builder: (context, state) {
                            if (state is FetchLoading) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (state is FetchProductsError) {
                              return Center(child: Text('Error: ${state.message}'));
                            } else if (state is FetchProductsSuccess) {
                              final products = state.productList;
                              if (products.isEmpty) {
                                return Center(child: Text('No products available', style: mainTextStyle));
                              }
                              return ListView.separated(
                                padding: const EdgeInsets.only(top: 20, bottom: 16),
                                itemCount: products.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 12),
                                itemBuilder: (context, index) => ProductCard(product: products[index]),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
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

class _Header extends StatelessWidget {
  final String username;
  const _Header({Key? key, this.username = 'User'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.of(context).size.width < 360;

    return SizedBox(
      height: 72,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome,',
                  style: mainTextStyle.copyWith(fontSize: 20),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  username,
                  style: mainTextStyle.copyWith(fontSize: 20),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          logoutButton(isNarrow: isNarrow),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                        onPressed: () {},
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
    );
  }
}

class _BottomNavigationBar extends StatelessWidget {
  const _BottomNavigationBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Container(
          height: 56,
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFF8F7FA), width: 1)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(mainAxisSize: MainAxisSize.min, children: const [Icon(Icons.home, size: 24), SizedBox(height: 4)]),
                Column(mainAxisSize: MainAxisSize.min, children: const [Icon(Icons.favorite_border, size: 20), SizedBox(height: 4)]),
                Column(mainAxisSize: MainAxisSize.min, children: const [Icon(Icons.shopping_cart, size: 24), SizedBox(height: 4)]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget logoutButton({ required bool isNarrow}) {

  return SizedBox(
    width: isNarrow ? 56 : 92,
    child: TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(56, 56), // гарантований мінімум для touch target
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // круглий фон під іконку
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFFFFF3CC), // блідо-жовтий (приблизно як на зображенні)
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.logout, // або іконка зі стрілкою, якщо хочете іншу — наприклад Icons.exit_to_app
                size: 20,
                color: Colors.black87,
              ),
            ),
          ),

          // відступ і текст тільки у широкому режимі
          if (!isNarrow) const SizedBox(height: 8),
          if (!isNarrow)
            Text(
              'Log out',
              style: buttonTextStyle.copyWith(color: Colors.black),
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    ),
  );
}

