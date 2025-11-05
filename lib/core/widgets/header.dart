import 'package:fake_store_prog/core/styles/text_styles.dart';
import 'package:fake_store_prog/core/widgets/logout_button.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String headerText;
  final String username;
  const Header({super.key, required this.headerText, this.username = ""});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 183,
      padding: const EdgeInsets.only(top: 56, left: 24, right: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 60,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(headerText, style: headerTextStyle),
                      if (username.isNotEmpty)
                        Text(username, style: headerTextStyle),
                    ],
                  ),
                ),
                const LogoutButton(),
              ],
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
