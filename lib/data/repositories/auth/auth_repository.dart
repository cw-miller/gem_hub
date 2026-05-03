import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _client;

  AuthRepository(this._client);

  /// EMAIL LOGIN
  Future<User?> login(String email, String password) async {
    final res = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    print("user : ${res.user}");
    print("session : ${res.session}");
    return res.user;
  }

  /// SIGN UP
  Future<User?> signUp(String email, String password) async {
    final res = await _client.auth.signUp(
      email: email,
      password: password,
    );
    print(res);
    return res.user;
  }

  /// 🔥 OAUTH LOGIN (Google, GitHub, etc.)
  Future<void> signInWithOAuth(OAuthProvider provider) async {
    await _client.auth.signInWithOAuth(
      provider,
      redirectTo: 'io.supabase.flutter://login-callback',
    );
  }

  /// LOGOUT
  Future<void> logout() async {
    await _client.auth.signOut();
  }

  /// CURRENT USER
  User? get currentUser => _client.auth.currentUser;

  /// AUTH STATE STREAM
  Stream<AuthState> get authState => _client.auth.onAuthStateChange;
}