import 'package:fake_store_prog/core/di/injection.dart';
import 'package:fake_store_prog/features/auth/bloc/auth_bloc.dart';
import 'package:fake_store_prog/ui/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureCoreDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthBloc>()),
      ],
      child: MainApp(),
    ),
  );
}


class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WelcomePage()
    );
  }
}
