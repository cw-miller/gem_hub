import 'package:job_market/data/models/job_market/job_model.dart';
import 'package:job_market/data/repositories/job_market/job_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_job_viewmodel.g.dart';

@riverpod
class PostJobViewModel extends _$PostJobViewModel {
  @override
  bool build() {
    return false;
  }

  Future<bool> publishJob(Job job) async {
    final repository = ref.read(jobRepositoryProvider);
    repository.insertJob(job);
    return true;
  }
}
