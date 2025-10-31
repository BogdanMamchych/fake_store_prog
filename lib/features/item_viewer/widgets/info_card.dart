import 'package:fake_store_prog/core/models/item.dart';
import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final Item item;
  const InfoCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item.title,
              style: const TextStyle(
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w600,
                fontSize: 24,
                color: Color.fromRGBO(0, 0, 0, 0.75),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              item.category,
              style: const TextStyle(
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color.fromRGBO(0, 0, 0, 0.5),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.star, size: 14, color: Colors.black),
                const SizedBox(width: 6),
                Text(
                  item.rating.toStringAsFixed(2),
                  style: const TextStyle(
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF303539),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${item.ratingCount} Reviews',
                  style: const TextStyle(
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFFA6A6AA),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
