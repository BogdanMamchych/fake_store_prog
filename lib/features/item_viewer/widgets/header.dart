import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final VoidCallback onBack;
  final bool isFavorite;

  const Header({
    super.key,
    required this.onBack,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: onBack,
            iconSize: 20,
            color: const Color(0xFF3A3A3A),
          ),
          Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            size: 16,
            color: const Color(0xFF3A3A3A),
          ),
        ],
      ),
    );
  }
}
