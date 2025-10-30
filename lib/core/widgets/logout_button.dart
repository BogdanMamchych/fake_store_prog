import 'package:fake_store_prog/core/styles/text_styles.dart';
import 'package:flutter/material.dart';

Widget logoutButton() {

  return SizedBox(
    width: 56,
    child: TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(56, 56),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFFFFF3CC),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.logout,
                size: 20,
                color: Colors.black87,
              ),
            ),
          ),

          const SizedBox(height: 8),
            Text(
              'Log out',
              style: buttonTextStyle.copyWith(color: Colors.black),
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    ),
  );
}

