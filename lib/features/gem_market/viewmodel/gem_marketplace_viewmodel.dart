import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:job_market/data/models/gem_market/gem_model.dart';
import 'package:job_market/data/repositories/gem_repository.dart';
import 'package:job_market/core/enums/gem_type.dart';

part 'gem_marketplace_viewmodel.g.dart';

@riverpod
class GemMarketplaceViewModel extends _$GemMarketplaceViewModel {
  String _currentQuery = '';
  GemType _currentType = GemType.allGems;

  @override
  Future<List<Gem>> build() async {
    return _fetchGemsFromRepo();
  }

  Future<List<Gem>> _fetchGemsFromRepo() async {
    final repository = ref.read(gemRepositoryProvider);
    return await repository.searchAndFilterGems(
      _currentQuery,
      _currentType,
    );
  }

  Future<void> updateSearchQuery(String query) async {
    _currentQuery = query;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchGemsFromRepo());
  }

  Future<void> updateType(GemType type) async {
    _currentType = type;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchGemsFromRepo());
  }

  Future<void> fetchGems() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchGemsFromRepo());
  }
  
  Future<bool> addGem(Gem gem) async {
    try {
      final repository = ref.read(gemRepositoryProvider);
      await repository.postNewGem(gem);
      await fetchGems();
      return true;
    } catch (e) {
      return false;
    }
  }
}

