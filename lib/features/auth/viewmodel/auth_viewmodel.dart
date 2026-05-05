import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:job_market/data/repositories/auth/auth_repository_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  // We return void because the ViewModel only tracks the STATUS of actions
  @override
  FutureOr<void> build() => null;

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      await repo.login(email, password);
      // We don't need to return the user; the sessionProvider picks it up
    });
  }

  Future<void> signUp(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signUp(email, password);
    });
  }

  Future<void> signInWithOAuth(OAuthProvider provider) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signInWithOAuth(provider);
    });
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).logout();
    });
  }
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
