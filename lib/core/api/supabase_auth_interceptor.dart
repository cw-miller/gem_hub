import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_market/core/providers/token/supabase_token_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthInterceptor extends Interceptor {
  final Ref _ref;

  SupabaseAuthInterceptor(this._ref);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final supabase = Supabase.instance.client;
    final session = supabase.auth.currentSession;

    // 1. Proactive Refresh
    if (session != null && session.isExpired) {
      try {
        await supabase.auth.refreshSession();
      } catch (_) {
        // Continue anyway; the backend will catch an invalid token
      }
    }

    // 2. SAFETY CHECK: The "Async Gap"
    // Since 'Ref' doesn't have '.mounted', we check if the container 
    // still has this provider active before reading.
    try {
      final token = _ref.read(currentAccessTokenProvider);
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e) {
      // If we hit this, the provider was likely disposed during the await.
      // We log it and let the request go through (or fail gracefully).
      print('SupabaseAuthInterceptor: Ref was disposed during async gap.');
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // If the Django backend rejects the token (401), 
    // it's a signal the session is totally dead.
    if (err.response?.statusCode == 401) {
      print('Auth Error: 401 Unauthorized from backend.');
    }
    return handler.next(err);
  }
}