import 'package:fake_store_prog/core/styles/text_styles.dart';
import 'package:flutter/material.dart';

Widget logoutButton({ required bool isNarrow}) {

  return SizedBox(
    width: isNarrow ? 56 : 92,
    child: TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(56, 56), // гарантований мінімум для touch target
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // круглий фон під іконку
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFFFFF3CC), // блідо-жовтий (приблизно як на зображенні)
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.logout, // або іконка зі стрілкою, якщо хочете іншу — наприклад Icons.exit_to_app
                size: 20,
                color: Colors.black87,
              ),
            ),
          ),

          // відступ і текст тільки у широкому режимі
          if (!isNarrow) const SizedBox(height: 8),
          if (!isNarrow)
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

