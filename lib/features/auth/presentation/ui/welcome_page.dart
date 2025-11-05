import 'package:fake_store_prog/core/styles/text_styles.dart';
import 'package:fake_store_prog/core/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/welcome_page_bg.png',
              fit: BoxFit.cover,
            ),
          ),

          Center(
            child: SizedBox(
              width: 375,
              height: 812,
              child: Stack(
                children: [
                  Positioned(
                    left: 159,
                    top: 448,
                    child: Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xFFF4D374), Color(0xFFF4D374)],
                        ),
                        border: Border.all(color: const Color(0xFFF4D374)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: const Color(0xFFF4D374), width: 1),
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/images/fake_store_logo.png',
                              width: 58,
                              height: 58,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    left: 118,
                    top: 523,
                    child: Text(
                      'Fake Store',
                      style: mainTextStyle,
                    ),
                  ),

                  Positioned(
                    left: 18,
                    right: 15,
                    top: 598,
                    child: SizedBox(
                      height: 48,
                      child: CustomElevatedButton(
                        text: 'Get Started',
                        onPressed: () {
                          context.push('/login');
                        },
                      ),
                    ),
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
