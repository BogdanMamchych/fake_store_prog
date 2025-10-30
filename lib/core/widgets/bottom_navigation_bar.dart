import 'package:fake_store_prog/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:fake_store_prog/features/cart/presentation/bloc/cart_event.dart';
import 'package:fake_store_prog/features/cart/presentation/ui/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

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
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.home, size: 24),
                    SizedBox(height: 4),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider<CartBloc>(
                                    create: (ctx) => GetIt.I<CartBloc>()..add(FetchCartEvent()),
                                    child: CartPage(),
                                  ),
                                ),
                              );
                      },
                      icon: Icon(Icons.shopping_cart, size: 24),
                    ),
                    SizedBox(height: 4),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
