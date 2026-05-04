import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Screens
import 'package:job_market/features/navigation/view/main_navigation.dart';
import 'package:job_market/features/marketplace/view/job_market.dart';
import 'package:job_market/features/gem_market/view/gem_market.dart';
import 'package:job_market/features/jobs/view/admin_screen.dart';
import 'package:job_market/features/auth/view/login_screen.dart';
import 'package:job_market/features/auth/view/sign_up_screen.dart';
import 'package:job_market/core/router/router_notifier.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter router(Ref ref) {
  final notifier = ref.watch(routerLogicProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/gems',
    refreshListenable: notifier, // 🔄 This tells GoRouter to refresh on auth changes
    redirect: notifier.redirect,   // 🛡️ This runs the auth logic
    
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainNavigation(child: child),
        routes: [
          GoRoute(
            path: '/jobs',
            name: 'jobs',
            builder: (context, state) => const JobMarketplaceScreen(),
          ),
          GoRoute(
            path: '/gems',
            name: 'gems',
            builder: (context, state) => const GemMarketPlaceScreen(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const JobMarketplaceScreen(),
          ),
          GoRoute(
            path: '/admin',
            name: 'admin',
            builder: (context, state) => const AdminJobReviewScreen(),
          ),
        ],
      ),
    ],
  );
}