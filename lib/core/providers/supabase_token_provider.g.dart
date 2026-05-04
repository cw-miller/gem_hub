// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supabase_token_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(accessTokenStream)
final accessTokenStreamProvider = AccessTokenStreamProvider._();

final class AccessTokenStreamProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, Stream<String?>>
    with $FutureModifier<String?>, $StreamProvider<String?> {
  AccessTokenStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accessTokenStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accessTokenStreamHash();

  @$internal
  @override
  $StreamProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<String?> create(Ref ref) {
    return accessTokenStream(ref);
  }
}

String _$accessTokenStreamHash() => r'5164ce7da8069d0e01d1019e4135e817ced93387';
