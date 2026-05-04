import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:job_market/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart'; // For ChangeNotifier and BuildContext
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

    // CRITICAL: If the provider is still in its very first load,
    // do NOT redirect. Stay on the splash/initial screen.
    print(authState);
    if (authState.isLoading && authState.value == null) {
      return null;
    }

    final bool isLoggedIn = authState.value != null;
    final String path = state.uri.path;
    final bool isGuestPage = path == '/login' || path == '/signup';

    // Only act once we are SURE we aren't loading the initial session
    if (!isLoggedIn) {
      return isGuestPage ? null : '/login';
    }

    if (isLoggedIn && isGuestPage) {
      return '/gems';
    }

    return null;
  }
}
