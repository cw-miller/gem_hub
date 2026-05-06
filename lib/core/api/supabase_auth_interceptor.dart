import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_market/core/providers/supabase_token_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthInterceptor extends Interceptor {
  final Ref _ref;

  SupabaseAuthInterceptor(this._ref);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final supabase = Supabase.instance.client;
    final session = supabase.auth.currentSession;

    // 1. Proactive Refresh: If the token is expired, refresh it before sending the request
    if (session != null && session.isExpired) {
      try {
        await supabase.auth.refreshSession();
      } catch (_) {
        // If refresh fails, let the request proceed; Django will return 401
      } 
    }

    // 2. Read the latest token from our provider
    final token = _ref.read(currentAccessTokenProvider);

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Continue the request
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Optional: Global error handling (e.g., redirect to login on 401)
    if (err.response?.statusCode == 401) {
      // Handle unauthorized error
    }
    return handler.next(err);
  }
}