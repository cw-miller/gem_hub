import 'dart:developer'; // Imported for the log() function
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:job_market/data/models/gem_market/gem_model.dart';
import 'package:job_market/data/repositories/gem_market/gem_repository_provider.dart';
import 'package:job_market/features/gem_market/provider/gem_list_provider.dart';

part 'gem_evaluate_viewmodel.g.dart';

@riverpod
class GemEvaluateViewModel extends _$GemEvaluateViewModel {
  @override
  FutureOr<void> build() {
    // Initial state is void
  }

  Future<bool> _performAction(String actionName, Future<void> Function() action) async {
    if (!ref.mounted) return false;
    state = const AsyncLoading();

    try {
      log('🚀 Starting Gem Action: $actionName');
      await action();

      if (!ref.mounted) return false;

      state = const AsyncData(null);
      log('✅ Gem Action Success: $actionName');
      return true;
    } catch (e, st) {
      // DEBUG LOGGING
      log('❌ Gem Action Error [$actionName]: $e');
      log('Stacktrace: $st');

      if (!ref.mounted) return false;

      state = AsyncValue.error(e, st);
      return false;
    }
  }

  // --- CREATE ---
  Future<bool> addGem(Gem gem) async {
    return _performAction('ADD_GEM', () async {
      await ref.read(gemRepositoryProvider).createGem(gem);
      ref.invalidate(gemListProvider);
    });
  }

  // --- UPDATE ---
  Future<bool> updateGem(Gem gem) async {
    return _performAction('UPDATE_GEM', () async {
      await ref.read(gemRepositoryProvider).updateGem(gem);
      ref.invalidate(gemListProvider);
    });
  }

  // --- DELETE ---
  Future<bool> deleteGem(String id) async {
    return _performAction('DELETE_GEM', () async {
      await ref.read(gemRepositoryProvider).deleteGem(id);
      ref.invalidate(gemListProvider);
    });
  }
}