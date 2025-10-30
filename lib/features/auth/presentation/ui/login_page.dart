import 'package:fake_store_prog/features/product_list/presentation/bloc/product_list_bloc.dart';
import 'package:fake_store_prog/features/product_list/presentation/bloc/product_list_event.dart';
import 'package:fake_store_prog/core/styles/text_styles.dart';
import 'package:fake_store_prog/features/product_list/presentation/ui/home_page.dart';
import 'package:fake_store_prog/core/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fake_store_prog/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fake_store_prog/features/auth/presentation/bloc/auth_event.dart';
import 'package:fake_store_prog/features/auth/presentation/bloc/auth_state.dart';
import 'package:get_it/get_it.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final username = _emailController.text.trim();
    final password = _passwordController.text;

    context.read<AuthBloc>().add(
      LoginRequested(username: username, password: password),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final width = mq.size.width;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login successful!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider<ProductListBloc>(
                create: (ctx) => GetIt.I<ProductListBloc>()..add(FetchProductsEvent()),
                child: const HomePage(),
              ),
            ),
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

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

                  const SizedBox(height: 48),

                  Text(
                    'Welcome back! Glad to see you, Again!',
                    style: mainTextStyle,
                  ),

                  const SizedBox(height: 34),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildInput(
                          controller: _emailController,
                          hint: 'Enter your username',
                          width: width - 44,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Please enter username';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        _buildInput(
                          controller: _passwordController,
                          hint: 'Enter your password',
                          obscure: _obscure,
                          width: width - 44,
                          suffix: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: Icon(
                              _obscure
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              size: 22,
                              color: const Color(0xFF6A707C),
                            ),
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Please enter password';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 24),

                        SizedBox(
                          width: 342,
                          height: 48,
                          child: BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              final loading = state is AuthLoading;
                              return CustomElevatedButton(
                                text: loading ? 'Logging in...' : 'Login',
                                onPressed: loading ? () {} : _onLoginPressed,
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    bool obscure = false,
    double? width,
    Widget? suffix,
    String? Function(String?)? validator,
  }) {
    return Container(
      width: width,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(),
      ),
      child: Row(
        children: [
          const SizedBox(width: 18),
          Expanded(
            child: TextFormField(
              controller: controller,
              obscureText: obscure,
              style: inputTextStyle,
              validator: validator,
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: hint,
                hintStyle: inputTextStyle,
              ),
            ),
          ),
          if (suffix != null) ...[
            const SizedBox(width: 8),
            SizedBox(width: 40, height: 40, child: suffix),
            const SizedBox(width: 6),
          ] else
            const SizedBox(width: 18),
        ],
      ),
    );
  }
}
