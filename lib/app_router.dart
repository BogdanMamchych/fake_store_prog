import 'package:fake_store_prog/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fake_store_prog/features/auth/presentation/bloc/auth_event.dart';
import 'package:fake_store_prog/features/cart/presentation/bloc/cart_event.dart';
import 'package:fake_store_prog/features/item_list/presentation/bloc/item_list_event.dart';
import 'package:fake_store_prog/features/item_viewer/presentation/bloc/item_viewer_bloc.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection.dart';
import 'core/models/item.dart';

import 'features/item_list/presentation/ui/home_page.dart';
import 'features/item_list/presentation/bloc/item_list_bloc.dart';

import 'features/auth/presentation/ui/login_page.dart';
import 'features/auth/presentation/ui/welcome_page.dart';

import 'features/cart/presentation/ui/cart_page.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';

import 'features/item_viewer/presentation/ui/item_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/welcome',
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) {
        return BlocProvider<ItemListBloc>(
          create: (_) => GetIt.I<ItemListBloc>()..add(FetchItemsRequested()),
          child: const HomePage(),
        );
      },
    ),

    GoRoute(
      path: '/welcome',
      name: 'welcome',
      builder: (context, state) => const WelcomePage(),
    ),

    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),

    GoRoute(
      path: '/logout',
      name: 'logout',
      builder: (context, state) {
        return BlocProvider<AuthBloc>(
          create: (_) => GetIt.I<AuthBloc>()..add(LogOutRequested()),
          child: const LoginPage(),
        );
      }
    ),

    GoRoute(
      path: '/cart',
      name: 'cart',
      builder: (context, state) {
        return BlocProvider<CartBloc>(
          create: (_) => GetIt.I<CartBloc>()..add(FetchCartRequested()),
          child: const CartPage(),
        );
      },
    ),

    GoRoute(
      path: '/product',
      name: 'product',
      builder: (context, state) {
        final extra = state.extra;
        if (extra is Item) {
          return BlocProvider.value(
            value: getIt<ItemViewerBloc>(),
            child: ItemPage(item: extra),
          );
        } else {
          return Scaffold(
            appBar: AppBar(title: const Text('Product')),
            body: const Center(child: Text('Product data not provided')),
          );
        }
      },
    ),
  ],
);
