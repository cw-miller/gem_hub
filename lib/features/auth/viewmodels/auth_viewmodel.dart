import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:job_market/data/repositories/auth/auth_repository_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  StreamSubscription<AuthState>? _sub;

  @override
  FutureOr<User?> build() {
    final repo = ref.read(authRepositoryProvider);

    // Listen to changes and update the state automatically
    _sub = repo.authState.listen((data) {
      state = AsyncData(data.session?.user);
    });

    ref.onDispose(() => _sub?.cancel());

    // This becomes the initial state of authViewModelProvider
    return repo.currentUser;
  }

  /// LOGIN
  Future<void> login(String email, String password) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      final user = await repo.login(email, password);

      if (user == null) {
        throw Exception("Login failed");
      }

      return user;
    });
  }

  /// SIGN UP
  Future<void> signUp(String email, String password) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      final user = await repo.signUp(email, password);

      if (user == null) {
        throw Exception("Signup failed");
      }

      return user;
    });
  }

  /// OAUTH LOGIN
  Future<void> signInWithOAuth(OAuthProvider provider) async {
    state = const AsyncLoading();

    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.signInWithOAuth(provider);
      // No manual state update — handled by authState listener
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// LOGOUT
  Future<void> logout() async {
    state = const AsyncLoading();

    await ref.read(authRepositoryProvider).logout();

    // Listener will also update this, but we set it immediately
    state = const AsyncData(null);
  }

  /// Derived state
  bool get isLoggedIn => state.value != null;

  // ============================
  // ✅ VALIDATION METHODS
  // ============================

  String? validateLogin(String email, String password) {
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

    return null;
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
