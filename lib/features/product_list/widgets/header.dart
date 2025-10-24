import 'package:fake_store_prog/features/product_list/widgets/logout_button.dart';
import 'package:fake_store_prog/core/styles/text_styles.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String username;
  const Header({super.key, this.username = 'User'});

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.of(context).size.width < 360;

    return SizedBox(
      height: 72,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome,',
                  style: mainTextStyle.copyWith(fontSize: 20),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  username,
                  style: mainTextStyle.copyWith(fontSize: 20),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          logoutButton(isNarrow: isNarrow),
        ],
      ),
    );
  }
}
