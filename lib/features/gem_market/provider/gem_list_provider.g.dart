// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gem_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(gemList)
final gemListProvider = GemListProvider._();

final class GemListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Gem>>,
          List<Gem>,
          FutureOr<List<Gem>>
        >
    with $FutureModifier<List<Gem>>, $FutureProvider<List<Gem>> {
  GemListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gemListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gemListHash();

  @$internal
  @override
  $FutureProviderElement<List<Gem>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Gem>> create(Ref ref) {
    return gemList(ref);
  }
}

String _$gemListHash() => r'4df0c200093987a18d755b7ca1877f73fb3aeb6d';

@ProviderFor(pendingGems)
final pendingGemsProvider = PendingGemsProvider._();

final class PendingGemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Gem>>,
          List<Gem>,
          FutureOr<List<Gem>>
        >
    with $FutureModifier<List<Gem>>, $FutureProvider<List<Gem>> {
  PendingGemsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingGemsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingGemsHash();

  @$internal
  @override
  $FutureProviderElement<List<Gem>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Gem>> create(Ref ref) {
    return pendingGems(ref);
  }
}

String _$pendingGemsHash() => r'ad60436e86aeab8f9bf6a70abb82360b5220eb5e';

/// Returns all gems approved for the marketplace

@ProviderFor(approvedGems)
final approvedGemsProvider = ApprovedGemsProvider._();

/// Returns all gems approved for the marketplace

final class ApprovedGemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Gem>>,
          List<Gem>,
          FutureOr<List<Gem>>
        >
    with $FutureModifier<List<Gem>>, $FutureProvider<List<Gem>> {
  /// Returns all gems approved for the marketplace
  ApprovedGemsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'approvedGemsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$approvedGemsHash();

  @$internal
  @override
  $FutureProviderElement<List<Gem>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Gem>> create(Ref ref) {
    return approvedGems(ref);
  }
}

String _$approvedGemsHash() => r'b41ce103c4c5afdd426795475d2046cade008bd9';

/// Returns the 10 most recently approved gems

@ProviderFor(latestAddedGems)
final latestAddedGemsProvider = LatestAddedGemsProvider._();

/// Returns the 10 most recently approved gems

final class LatestAddedGemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Gem>>,
          List<Gem>,
          FutureOr<List<Gem>>
        >
    with $FutureModifier<List<Gem>>, $FutureProvider<List<Gem>> {
  /// Returns the 10 most recently approved gems
  LatestAddedGemsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'latestAddedGemsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$latestAddedGemsHash();

  @$internal
  @override
  $FutureProviderElement<List<Gem>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Gem>> create(Ref ref) {
    return latestAddedGems(ref);
  }
}

String _$latestAddedGemsHash() => r'74493d0d6d2f48bad990c5a050b6e8b6b8c5b645';
