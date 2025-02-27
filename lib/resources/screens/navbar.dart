import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:signals/signals_flutter.dart';
import 'package:vocary/app/signals/navbar_signal.dart';
import 'package:vocary/router/routes.dart';

class NavBar extends StatefulWidget {
  final Widget child;
  const NavBar({super.key, required this.child});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  final List<String> _routes = [
    AppRoutes.home,
    AppRoutes.review,
    AppRoutes.profile,
  ];
  final List<IconData> _icons = [
    LucideIcons.graduationCap,
    LucideIcons.bookOpenCheck,
    LucideIcons.circleUserRound,
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    context.go(_routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Watch(
        (context) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height:
              NavBarSignals.isVisible.value ? kBottomNavigationBarHeight : 0,
          child: Wrap(
            children: [
              if (NavBarSignals.isVisible.value)
                AnimatedBottomNavigationBar(
                  iconSize: 28,
                  backgroundColor: ShadTheme.of(context).colorScheme.background,
                  splashColor: ShadTheme.of(context).colorScheme.primary,
                  activeColor: ShadTheme.of(context).colorScheme.primary,
                  inactiveColor: ShadTheme.of(
                    context,
                  ).colorScheme.primary.withAlpha(80),
                  borderWidth: 1,
                  borderColor: ShadTheme.of(context).colorScheme.border,
                  icons: _icons,
                  activeIndex: _selectedIndex,
                  notchSmoothness: NotchSmoothness.verySmoothEdge,
                  gapLocation: GapLocation.none,
                  onTap: _onItemTapped,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
