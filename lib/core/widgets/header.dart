import 'package:fake_store_prog/core/widgets/logout_button.dart';
import 'package:fake_store_prog/core/styles/text_styles.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String headerText;
  final String username;
  const Header({super.key, required this.headerText, this.username = ""});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          username != "" && headerText.startsWith("Welcome")
              ? Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome,',
                        style: mainTextStyle.copyWith(fontSize: 24),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        username,
                        style: mainTextStyle.copyWith(fontSize: 24),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                )
              : Expanded(
                  child: Text(
                    headerText,
                    style: mainTextStyle.copyWith(fontSize: 24),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

          const LogoutButton(),
        ],
      ),
    );
  }
}
