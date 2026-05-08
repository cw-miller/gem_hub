import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:job_market/core/api/supabase_auth_interceptor.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

part 'dio_provider.g.dart';

@riverpod
Dio dio(Ref ref) {
  final rawBaseUrl = dotenv.env['API_BASE_URL'];

  if (rawBaseUrl == null) {
    throw Exception("API_BASE_URL not found in .env file");
  }

  // FIX: Ensure baseUrl ends with /
  final baseUrl = rawBaseUrl.endsWith('/') ? rawBaseUrl : '$rawBaseUrl/';

  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      // Optional: Add this to handle Django's 301 redirects better
      followRedirects: true,
      validateStatus: (status) => status! < 500,
    ),
  );

  dio.interceptors.add(SupabaseAuthInterceptor(ref));
  dio.interceptors.add(
    LogInterceptor(
      request: true, // Ensures the URL/Method is printed
      requestHeader: true, // Prints the headers
      requestBody: true, // Prints the data you are sending
      responseHeader: false,
      responseBody: true,
      error: true,
    ),
  );

  return dio;
}
