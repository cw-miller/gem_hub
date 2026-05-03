import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:job_market/core/providers/supabase_provider.dart';

part 'supabase_token_provider.g.dart';

@riverpod
String? accessToken(Ref ref) {
  final client = ref.watch(supabaseProvider);

  final session = client.auth.currentSession;
  return session?.accessToken;
}