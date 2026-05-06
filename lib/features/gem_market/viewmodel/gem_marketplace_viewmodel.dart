import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:job_market/data/models/gem_market/gem_model.dart';
import 'package:job_market/data/repositories/gem/gem_repository_provider.dart';

part 'gem_marketplace_viewmodel.g.dart';

@riverpod
class GemMarketplaceViewModel extends _$GemMarketplaceViewModel {
  
  @override
  Future<List<Gem>> build() async {
    return _fetchGemsFromRepo();
  }

  /// Private helper to handle the data fetch
  Future<List<Gem>> _fetchGemsFromRepo() async {
    final repository = ref.read(gemRepositoryProvider);
    // Simple fetch without query/filter for now
    return await repository.getAllGems();
  }

  /// Public method to manually refresh the list (pull-to-refresh)
  Future<void> fetchGems() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchGemsFromRepo());
  }

  /// CREATE: Add a new gem and refresh the list
  Future<bool> addGem(Gem gem) async {
    final repository = ref.read(gemRepositoryProvider);
    
    final result = await AsyncValue.guard(() async {
      await repository.createGem(gem);
      return _fetchGemsFromRepo();
    });

    if (result.hasValue) {
      state = result;
      return true;
    }
    return false;
  }

  /// UPDATE: Modify an existing gem
  Future<bool> updateGem(Gem gem) async {
    final repository = ref.read(gemRepositoryProvider);

    final result = await AsyncValue.guard(() async {
      await repository.updateGem(gem);
      return _fetchGemsFromRepo();
    });

    if (result.hasValue) {
      state = result;
      return true;
    }
    return false;
  }

  /// DELETE: Remove a gem and refresh the state
  Future<bool> deleteGem(String id) async {
    final repository = ref.read(gemRepositoryProvider);

    final result = await AsyncValue.guard(() async {
      await repository.deleteGem(id);
      return _fetchGemsFromRepo();
    });

    if (result.hasValue) {
      state = result;
      return true;
    }
    return false;
  }
}