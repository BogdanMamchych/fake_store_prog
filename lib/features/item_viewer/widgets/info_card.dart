import 'package:fake_store_prog/core/models/item.dart';
import 'package:flutter/material.dart';
import 'package:fake_store_prog/core/styles/text_styles.dart';

class InfoCard extends StatelessWidget {
  final Item item;
  const InfoCard({super.key, required this.item});

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
              style: itemViewerTitleTextStyle,
            ),
            const SizedBox(height: 6),
            Text(
              item.category,
              style: categoryTextStyle,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.star,
                  size: 14,
                  color: itemCardRatingStyle.color ?? Colors.black,
                ),
                const SizedBox(width: 6),
                Text(
                  item.rating.toStringAsFixed(2),
                  style: itemCardRatingStyle.copyWith(fontSize: 14),
                ),
                const SizedBox(width: 8),
                Text(
                  '${item.ratingCount} Reviews',
                  style: itemCardDescriptionStyle.copyWith(
                    fontSize: 14,
                    color: const Color(0xFFA6A6AA),
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
