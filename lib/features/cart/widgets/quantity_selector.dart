import 'package:fake_store_prog/features/cart/widgets/icon_btn.dart';
import 'package:fake_store_prog/core/styles/text_styles.dart';
import 'package:flutter/material.dart';

class QuantitySelector extends StatelessWidget {
  final int value;
  final VoidCallback? onIncrease;
  final VoidCallback? onDecrease;

  const QuantitySelector({
    super.key,
    required this.value,
    this.onIncrease,
    this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 134,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.black.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconBtn(icon: Icons.remove, onTap: onDecrease),
          Container(width: 1, height: 36, color: const Color(0xFFD9D9D9)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              '$value',
              style: quantitySelectorValueStyle,
            ),
          ),
          Container(width: 1, height: 36, color: const Color(0xFFD9D9D9)),
          IconBtn(icon: Icons.add, onTap: onIncrease),
        ],
      ),
    );
  }
}
