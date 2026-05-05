// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AuthViewModel)
final authViewModelProvider = AuthViewModelProvider._();

final class AuthViewModelProvider
    extends $AsyncNotifierProvider<AuthViewModel, AuthenticatedUser> {
  AuthViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authViewModelHash();

  @$internal
  @override
  AuthViewModel create() => AuthViewModel();
}

String _$authViewModelHash() => r'459c2f624bc5b2b40023ad8d0ab19206ea855eda';

abstract class _$AuthViewModel extends $AsyncNotifier<AuthenticatedUser> {
  FutureOr<AuthenticatedUser> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<AuthenticatedUser>, AuthenticatedUser>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AuthenticatedUser>, AuthenticatedUser>,
              AsyncValue<AuthenticatedUser>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
