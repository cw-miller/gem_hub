import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:job_market/data/repositories/auth/auth_repository_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:job_market/data/models/auth/auth_state.dart';
import 'package:job_market/data/models/auth/profile_model.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  StreamSubscription<AuthState>? _sub;

  @override
  FutureOr<AuthenticatedUser> build() async {
    final repo = ref.read(authRepositoryProvider);

    _sub = repo.authState.listen((data) async {
      final supabaseUser = data.session?.user;

      if (supabaseUser == null) {
        state = AsyncData(AuthenticatedUser(supabaseUser: null, profile: null));
      } else {
        state = const AsyncLoading();
        state = await AsyncValue.guard(() async {
          final profile = await _fillProfile(supabaseUser);
          return AuthenticatedUser(
            supabaseUser: supabaseUser,
            profile: profile,
          );
        });
      }
    });

    ref.onDispose(() => _sub?.cancel());

    final currentUser = repo.currentUser;
    final profile = await _fillProfile(currentUser);
    return AuthenticatedUser(supabaseUser: currentUser, profile: profile);
  }

  Future<ProfileUser?> _fillProfile(User? supabaseUser) async {
    if (supabaseUser == null) return null;
    final repo = ref.read(authRepositoryProvider);
    try {
      return await repo.getUserProfile(supabaseUser.id);
    } catch (e) {
      return null;
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);

      // Step A: Auth Check
      final user = await repo.login(email, password);
      print('DEBUG: Step A - Supabase Auth successful for UID: ${user?.id}');

      // Step B: Profile Check
      final profile = await _fillProfile(user);
      if (profile == null) {
        print(
          'DEBUG: Step B - FAILED. Auth was successful, but NO PROFILE was found in the DB.',
        );
        throw Exception('Profile not found. Please contact support.');
      }

      print('DEBUG: Step C - Profile loaded with role: ${profile.role}');
      return AuthenticatedUser(supabaseUser: user, profile: profile);
    });
  }

  /// SIGN UP
  Future<void> signUp(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      final user = await repo.signUp(email, password);
      // After signup, the listener usually picks up the session,
      // but we return the state here to complete the Guard.
      final profile = await _fillProfile(user);
      return AuthenticatedUser(supabaseUser: user, profile: profile);
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
    state = AsyncData(AuthenticatedUser(supabaseUser: null, profile: null));
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
