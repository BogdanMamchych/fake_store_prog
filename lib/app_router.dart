import 'package:fake_store_prog/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'features/auth/presentation/ui/login_page.dart';
import 'features/auth/presentation/ui/welcome_page.dart';
import 'features/product_list/presentation/ui/home_page.dart';
import '/features/product_viewer/ui/product_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return BlocProvider.value(
          value: BlocProvider.of<AuthBloc>(context),
          child: const WelcomePage(),
        );
      },
    ),
    GoRoute(
      path: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: 'product/:productId',
      builder: (context, state) {
             final productId = int.parse(state.pathParameters['productId'] ?? '0');
             return ProductPage(productId: productId);
           },
    ),
    GoRoute(
      path: 'welcome',
      builder: (context, state) => const WelcomePage(),
    ),
  ],
);