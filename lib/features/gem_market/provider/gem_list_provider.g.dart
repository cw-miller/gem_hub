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
