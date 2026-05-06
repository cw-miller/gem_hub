import 'package:job_market/features/auth/provider/session_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:job_market/data/repositories/gem/gem_repository_provider.dart';
import 'package:job_market/data/models/gem_market/gem_model.dart';

part 'gem_list_provider.g.dart';                                                                                                                          

@riverpod
Future<List<Gem>> gemList(Ref ref) async {
  // 1. Watch the session. If user logs out, this automatically resets.
  final sessionAsync = ref.watch(sessionProvider);
  final user = sessionAsync.value;

  // 2. Simple Guard: No user? Return empty.
  if (user == null) return [];

  // 3. Fetch from Django
  return await ref.read(gemRepositoryProvider).getAllGems();
}