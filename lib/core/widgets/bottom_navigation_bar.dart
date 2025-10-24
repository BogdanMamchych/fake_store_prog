import 'package:flutter/material.dart';

class BottomNavigationBar extends StatelessWidget {
  const BottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Container(
          height: 56,
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFF8F7FA), width: 1)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(mainAxisSize: MainAxisSize.min, children: const [Icon(Icons.home, size: 24), SizedBox(height: 4)]),
                Column(mainAxisSize: MainAxisSize.min, children: const [Icon(Icons.favorite_border, size: 20), SizedBox(height: 4)]),
                Column(mainAxisSize: MainAxisSize.min, children: const [Icon(Icons.shopping_cart, size: 24), SizedBox(height: 4)]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
