import 'package:fake_store_prog/core/styles/text_styles.dart';
import 'package:fake_store_prog/features/auth/presentation/ui/login_page.dart';
import 'package:fake_store_prog/core/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/welcome_page_bg.png', fit: BoxFit.cover),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.55,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: Image.asset('assets/images/fake_store_logo.png'),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Fake Store',
                  style: mainTextStyle
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: SizedBox(
                    width: 342,
                    height: 48,
                    child: CustomElevatedButton(
                      text: 'Get Started',
                      onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));},
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
