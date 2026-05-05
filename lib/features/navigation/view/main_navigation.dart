import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:job_market/core/enums/user_role.dart';
import 'package:job_market/features/auth/provider/session_provider.dart'; // Updated import
import 'package:job_market/shared/widgets/app_header.dart';
import 'package:job_market/shared/widgets/bottom_navigation_bar.dart';

class MainNavigation extends ConsumerWidget {
  final Widget child;

  const MainNavigation({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Watch the SESSION instead of the ViewModel for stable user data
    final sessionAsync = ref.watch(sessionProvider);
    final user = sessionAsync.value;
    
    // 2. Get location from context
    final location = GoRouterState.of(context).uri.path;
    
    // 3. Determine index based on path (Cleaner logic)
    int currentIndex = 0;
    if (location.startsWith('/jobs')) {
      currentIndex = 0;
    } else if (location.startsWith('/gems')) {
      currentIndex = 1;
    } else if (location.startsWith('/profile')) {
      currentIndex = 2;
    }

    // 4. Theme and Role logic
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF111827) : const Color(0xFFF5F7FA);
    
    // Safe role check: If data is still loading, default to false
    final isAdmin = user?.profile?.role == UserRole.ADMIN;

    return Scaffold(
      backgroundColor: backgroundColor,
      // Use resizeToAvoidBottomInset to prevent UI squash when keyboard opens
      resizeToAvoidBottomInset: false, 
      body: SafeArea(
        child: Column(
          children: [
            // AppHeader now stays visible and stable
            Container(
              color: backgroundColor,
              child: const AppHeader(),
            ),
            // The routed screen content
            Expanded(child: child),
          ],
        ),
      ),
      // Only show the bottom bar for non-admins
      bottomNavigationBar: isAdmin 
        ? null 
        : AppBottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              // Direct mapping for cleaner readability
              final routes = ['/jobs', '/gems', '/profile'];
              if (index >= 0 && index < routes.length) {
                context.go(routes[index]);
              }
            },
          ),
    );
  }
}