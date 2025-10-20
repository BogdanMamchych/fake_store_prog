import 'package:fake_store_prog/styles/text_styles.dart';
import 'package:fake_store_prog/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final width = mq.size.width;

    return Scaffold(
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
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 16,
                      ),
                    ),
                  ),
                ),
        
                const SizedBox(height: 48),
        
                // Title
                Text(
                  'Welcome back! Glad to see you, Again!',
                  style: mainTextStyle
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
                            _obscure ? Icons.visibility_off : Icons.visibility,
                            size: 22,
                          color: const Color(0xFF6A707C),
                          ),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                      ),
        
                      const SizedBox(height: 24),
        
                      SizedBox(
                        width: 342,
                        height: 48,
                        child: CustomElevatedButton(
                          text: 'Login',
                          onPressed: _onLoginPressed,
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
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    bool obscure = false,
    double? width,
    Widget? suffix,
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
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: hint,
                hintStyle: inputTextStyle
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

  void _onLoginPressed() {
    if (_formKey.currentState?.validate() ?? true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login pressed (stub)')),
      );
    }
  }
}

/*
  PUBSPEC HINTS:

  fonts:
    - family: Urbanist
      fonts:
        - asset: assets/fonts/Urbanist-Regular.ttf
        - asset: assets/fonts/Urbanist-Medium.ttf
          weight: 500
        - asset: assets/fonts/Urbanist-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/Urbanist-Bold.ttf
          weight: 700

  assets:
    - assets/images/login_page_bg.png

  You can replace the font usage with GoogleFonts. For a commercial app ensure you follow the font license.
*/
