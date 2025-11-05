import 'package:fake_store_prog/core/widgets/custom_elevated_button.dart';
import 'package:fake_store_prog/core/styles/text_styles.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  final double price;
  final VoidCallback onAddToCart;

  const BottomBar({super.key, required this.price, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    final bottomColor = const Color(0xFFFFE8B2);

    return Container(
      height: 96, 
      color: bottomColor,
      padding: const EdgeInsets.symmetric(horizontal: 24), 
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Price',
                style: priceLabelTextStyle,
              ),
              const SizedBox(height: 6),
              Text('\$${price.toStringAsFixed(2)}', style: priceTextStyle),
            ],
          ),
          const Spacer(),

          SizedBox(
            width: 258,
            height: 48,
            child: CustomElevatedButton(
              onPressed: onAddToCart,
              text: 'Add to cart',
            ),
          ),
        ],
      ),
    );
  }
}
