import 'package:fake_store_prog/core/styles/elevated_button_styles.dart';
import 'package:fake_store_prog/core/styles/text_styles.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends SizedBox {
  CustomElevatedButton({
    required String text,
    required VoidCallback onPressed,
    super.key,
  }) : super(
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: blackElevatedButtonStyle,
              onPressed: onPressed,
              child: Text(text, style: buttonTextStyle,),
            ),
          ),
        );
}