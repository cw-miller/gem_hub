import 'package:job_market/data/models/job_market/job_model.dart';
import 'package:job_market/data/repositories/job_market/job_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'marketplace_viewmodel.g.dart';

@riverpod
class MarketplaceViewModel extends _$MarketplaceViewModel {
  String _currentQuery = '';
  String _currentCategory = 'All Jobs';

  @override
  Future<List<Job>> build() async {
    return _fetchJobsFromRepo();
  }

  Future<List<Job>> _fetchJobsFromRepo() async {
    final repository = ref.read(jobRepositoryProvider);
    return await repository.searchAndFilterJobs(
      _currentQuery,
      _currentCategory,
    );
  }

  Future<void> updateSearchQuery(String query) async {
    _currentQuery = query;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchJobsFromRepo());
  }

  Future<void> updateCategory(String category) async {
    _currentCategory = category;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchJobsFromRepo());
  }

  Future<void> fetchJobs() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchJobsFromRepo());
  }
}
