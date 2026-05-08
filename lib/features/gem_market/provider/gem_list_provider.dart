import 'package:job_market/features/auth/provider/session_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:job_market/data/repositories/gem_market/gem_repository_provider.dart';
import 'package:job_market/data/models/gem_market/gem_model.dart';
import 'package:job_market/core/enums/gem_status.dart';

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

@riverpod
Future<List<Gem>> pendingGems(Ref ref) async {
  final allGems = await ref.watch(gemListProvider.future);
  return allGems.where((gem) => gem.status == GemStatus.PENDING).toList();
}

/// Returns all gems approved for the marketplace
@riverpod
Future<List<Gem>> approvedGems(Ref ref) async {
  final allGems = await ref.watch(gemListProvider.future);
  return allGems.where((gem) => gem.status == GemStatus.APPROVED).toList();
}

/// Returns the 10 most recently approved gems
@riverpod
Future<List<Gem>> latestAddedGems(Ref ref) async {
  // Chain to approvedGems so we only show what's actually visible
  final approved = await ref.watch(approvedGemsProvider.future);
  
  // Reverse to get the newest first (assuming sequential API response)
  return approved.reversed.take(10).toList();
}