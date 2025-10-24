// lib/pages/product_page.dart

import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onToggleFav;
  final bool isFavorite;

  const Header({
    Key? key,
    required this.onBack,
    required this.onToggleFav,
    required this.isFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: onBack,
          ),
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: const Color(0xFF3A3A3A),
            ),
            onPressed: onToggleFav,
          ),
        ],
      ),
    );
  }
}
