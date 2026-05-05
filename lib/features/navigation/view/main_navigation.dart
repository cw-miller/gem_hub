import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:job_market/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:job_market/core/enums/user_role.dart';
import 'package:job_market/shared/widgets/app_header.dart';
import 'package:job_market/shared/widgets/bottom_navigation_bar.dart';

class MainNavigation extends ConsumerWidget {
  final Widget child;

  const MainNavigation({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Watch the auth state to get the current role
    final authState = ref.watch(authViewModelProvider);
    final location = GoRouterState.of(context).uri.toString();
    
    // 2. Determine index based on path
    int currentIndex = 0;
    if (location.startsWith('/jobs')) currentIndex = 0;
    if (location.startsWith('/gems')) currentIndex = 1;
    if (location.startsWith('/profile')) currentIndex = 2;

    // 3. Theme logic
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF111827) : const Color(0xFFF5F7FA);
    
    final user = authState.value;
    final isAdmin = user?.profile?.role == UserRole.ADMIN;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: backgroundColor,
              child: const AppHeader(),
            ),
            // 👇 Routed screen
            Expanded(child: child),
          ],
        ),
      ),
      // Only show the standard bottom bar for non-admins (Seekers/Recruiters)
      // or customize it based on your admin design.
      bottomNavigationBar: isAdmin 
        ? null // Admins might use a Sidebar or different navigation
        : AppBottomNavigationBar(
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