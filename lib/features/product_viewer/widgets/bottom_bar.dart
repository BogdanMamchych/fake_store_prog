// lib/pages/product_page.dart

import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  final double price;
  final VoidCallback onAddToCart;

  const BottomBar({Key? key, required this.price, required this.onAddToCart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottomColor = const Color(0xFFFFE8B2);
    final priceTextStyle = const TextStyle(
      fontFamily: 'Lora',
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Color(0xFF3A3A3A),
    );

    return Container(
      color: bottomColor,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          // Price
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Price',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF616161),
                ),
              ),
              const SizedBox(height: 6),
              Text('\$${price.toStringAsFixed(2)}', style: priceTextStyle),
            ],
          ),
          const Spacer(),

          // Add to cart button
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: onAddToCart,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E1E1E),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                padding: const EdgeInsets.symmetric(horizontal: 24),
              ),
              child: const Text(
                'Add to cart',
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
