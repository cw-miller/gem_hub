import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:job_market/core/providers/supabase_provider.dart';

part 'supabase_token_provider.g.dart';

@riverpod
Stream<String?> accessTokenStream(Ref ref) {
  final client = ref.watch(supabaseProvider);
  return client.auth.onAuthStateChange.map((data) => data.session?.accessToken);
}