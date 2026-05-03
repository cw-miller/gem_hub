import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:job_market/shared/widgets/app_header.dart';
import 'package:job_market/shared/widgets/bottom_navigation_bar.dart';

class MainNavigation extends StatelessWidget {
  final Widget child;

  const MainNavigation({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    int currentIndex = 0;

    if (location.startsWith('/jobs')) currentIndex = 0;
    if (location.startsWith('/gems')) currentIndex = 1;
    if (location.startsWith('/profile')) currentIndex = 2;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF111827) : const Color(0xFFF5F7FA),

      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: isDark
                  ? const Color(0xFF111827)
                  : const Color(0xFFF5F7FA),
              child: const AppHeader(),
            ),

            // 👇 Routed screen
            Expanded(child: child),
          ],
        ),
      ),

      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/jobs');
              break;
            case 1:
              context.go('/gems');
              break;
            case 2:
              context.go('/profile');
              break;
          }
        },
      ),
    );
  }
}