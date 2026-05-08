// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gem_evaluate_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GemEvaluateViewModel)
final gemEvaluateViewModelProvider = GemEvaluateViewModelProvider._();

final class GemEvaluateViewModelProvider
    extends $AsyncNotifierProvider<GemEvaluateViewModel, void> {
  GemEvaluateViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gemEvaluateViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gemEvaluateViewModelHash();

  @$internal
  @override
  GemEvaluateViewModel create() => GemEvaluateViewModel();
}

String _$gemEvaluateViewModelHash() =>
    r'69123170fb0055c41e715c381bd6d95e4f487e94';

abstract class _$GemEvaluateViewModel extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
