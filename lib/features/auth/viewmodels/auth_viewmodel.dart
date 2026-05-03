import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:job_market/data/repositories/auth/auth_repository_provider.dart';
// 1. ADD THIS IMPORT to recognize OAuthProvider
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  @override
  FutureOr<bool?> build() {
    // Check if user is already logged in on startup
    final user = ref.read(authRepositoryProvider).currentUser;
    return user != null;
  }

  Future<bool> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      final user = await repo.login(email, password);
      return user != null;
    });

    print("state value : ${state.value}");
    return state.value ?? false;
  }

  Future<bool> signUp(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      final user = await repo.signUp(email, password);
      return user != null;
    });
    return state.value ?? false;
  }

  /// 2. UPDATED: Generic OAuth method for any provider
  Future<void> signInWithOAuth(OAuthProvider provider) async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.signInWithOAuth(provider);
      // Note: We don't set success here because the app will
      // restart/redirect. The build() or a listener handles the new state.
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncData(false);
  }

  bool? get isLoggedIn => state.value;

  String? validateLogin(String email, String password) {
    if (email.trim().isEmpty) {
      return 'Username is required';
    }

    if (password.isEmpty) {
      return 'Password is required';
    }

    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null; // no errors
  }

  String? validateSignUp(
    String email,
    String password,
    String confirmPassword,
  ) {
    if (email.trim().isEmpty) {
      return 'Email is required';
    }

    if (!email.contains('@')) {
      return 'Enter a valid email';
    }

    if (password.isEmpty) {
      return 'Password is required';
    }

    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }

    if (confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }

    if (password != confirmPassword) {
      return 'Passwords do not match';
    }

    return null;
  }
}
