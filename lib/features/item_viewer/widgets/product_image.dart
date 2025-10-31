import 'package:flutter/material.dart';

class ItemImage extends StatelessWidget {
  final String imageUrl;
  const ItemImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Container(
          width: 267,
          height: 204,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
