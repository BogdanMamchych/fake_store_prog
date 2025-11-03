import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  static const double _height = 64.0;

  @override
  Widget build(BuildContext context) {
    String location = '/';
      final config = GoRouter.of(context).routerDelegate.currentConfiguration;
      location = config.uri.toString();


    final bool isCart = location.startsWith('/cart');
    final int selectedIndex = isCart ? 1 : 0;

    final theme = Theme.of(context);
    final selectedColor = theme.colorScheme.onPrimary == Colors.black
        ? theme.colorScheme.primary
        : theme.colorScheme.primary;
    final unselectedColor = Colors.black54;

    Widget buildItem({
      required IconData icon,
      required int index,
      required VoidCallback onTap,
    }) {
      final bool selected = index == selectedIndex;

      // Стиль контейнера для підсвітки самої іконки
      final Decoration selectedDecoration = BoxDecoration(
        color: Colors.white, // фон всередині рамки (за потреби змінити)
        border: Border.all(color: selectedColor, width: 1.6),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Color(0x08000000), blurRadius: 4, offset: Offset(0, 1)),
        ],
      );

      return Expanded(
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: SizedBox(
            height: _height,
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: selected ? const EdgeInsets.all(8) : EdgeInsets.zero,
                decoration: selected ? selectedDecoration : null,
                child: Icon(
                  icon,
                  size: 24,
                  color: selected ? selectedColor : unselectedColor,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Container(
          height: _height,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Color(0x11000000), blurRadius: 4, offset: Offset(0, -1)),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildItem(
                icon: Icons.home_outlined,
                index: 0,
                onTap: () {
                  if (selectedIndex != 0) {
                    context.go('/');
                  }
                },
              ),
              buildItem(
                icon: Icons.shopping_bag_outlined,
                index: 1,
                onTap: () {
                  if (selectedIndex != 1) {
                    context.go('/cart');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
