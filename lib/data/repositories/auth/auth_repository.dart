import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:job_market/data/models/auth/profile_model.dart';

class AuthRepository {
  final SupabaseClient _client;

  AuthRepository(this._client);

  /// EMAIL LOGIN
  Future<User?> login(String email, String password) async {
    final res = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    // Ensure session is valid
    if (res.session == null) {
      throw Exception("Login failed: No active session");
    }

    return res.user;
  }

  /// SIGN UP
  Future<User?> signUp(String email, String password) async {
    final res = await _client.auth.signUp(email: email, password: password);

    return res.user;
  }

  /// OAUTH LOGIN
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

  Future<ProfileUser?> getUserProfile(String userId) async {
  try {
    final response = await _client
        .from('profiles')
        .select()
        .eq('profile_id', userId)
        .maybeSingle();

    print('RAW DATABASE DATA: $response');

    if (response == null) {
      print('Query returned nothing for ID: $userId');
      return null;
    }

    // This is the line that is likely failing
    final model = ProfileUser.fromMap(response);
    print('MAPPING SUCCESS: ${model.username}');
    return model;
    
  } catch (e, stacktrace) {
    print('CRASH DURING FETCH/MAP: $e');
    print('STACKTRACE: $stacktrace');
    return null;
  }
}

  /// CURRENT USER (non-reactive)
  User? get currentUser => _client.auth.currentUser;

  /// CURRENT SESSION
  Session? get currentSession => _client.auth.currentSession;

  /// AUTH STATE STREAM (reactive 🔥)
  Stream<AuthState> get authState => _client.auth.onAuthStateChange;

  /// Quick check (non-reactive)
  bool get isLoggedIn => _client.auth.currentSession != null;
}
