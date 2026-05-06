import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:job_market/core/api/supabase_auth_interceptor.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


part 'dio_provider.g.dart';


@riverpod
Dio dio(Ref ref) {
  // No await needed here anymore
  final baseUrl = dotenv.env['API_BASE_URL'];
  
  if (baseUrl == null) {
    throw Exception("API_BASE_URL not found in .env file");
  }

  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Add the Supabase Auth Interceptor
  dio.interceptors.add(SupabaseAuthInterceptor(ref));
  
  // LogInterceptor is great for dev
  dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

  return dio;
}