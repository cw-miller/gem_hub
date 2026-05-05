import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:job_market/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart'; // For ChangeNotifier and BuildContext
import 'package:go_router/go_router.dart';
import 'package:job_market/core/enums/user_role.dart';
import 'package:job_market/data/models/auth/auth_state.dart';

part 'router_notifier.g.dart';

@riverpod
RouterNotifier routerLogic(Ref ref) {
  // Change name to authNotifier
  return RouterNotifier(ref);
}

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    // Listen to the auth state. Whenever it changes, we call notifyListeners()
    // which tells GoRouter to re-run its redirect logic.
    _ref.listen(authViewModelProvider, (_, __) => notifyListeners());
  }
  String? redirect(BuildContext context, GoRouterState state) {
    final authState = _ref.read(authViewModelProvider);
    if (authState.isLoading && authState.value == null) return null;

    final AuthenticatedUser? user = authState.value;
    final bool isAuth = user?.supabaseUser != null;
    final userRole = user
        ?.profile
        ?.role; // Ensure your Profile model maps 'role' string to Enum

    final String path = state.uri.path;
    final bool isGuestPage = path == '/login' || path == '/signup';

    if (!isAuth) {
      return isGuestPage ? null : '/login';
    }

    if (isAuth) {
      // If we have a session but profile failed to load
      if (userRole == null) {
        print('Router Warning: User is Authenticated but Role is NULL');
        return null;
      }

      if (isGuestPage || path == '/') {
        return (userRole == UserRole.ADMIN) ? '/admin' : '/gems';
      }

      if (path.startsWith('/admin') && userRole != UserRole.ADMIN) {
        return '/gems';
      }
    }

    return null;
  }
}
