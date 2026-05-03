// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_job_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PostJobViewModel)
final postJobViewModelProvider = PostJobViewModelProvider._();

final class PostJobViewModelProvider
    extends $NotifierProvider<PostJobViewModel, bool> {
  PostJobViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postJobViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postJobViewModelHash();

  @$internal
  @override
  PostJobViewModel create() => PostJobViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$postJobViewModelHash() => r'9100b70e830f0eb5b007baf324f02a44122614a6';

abstract class _$PostJobViewModel extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
