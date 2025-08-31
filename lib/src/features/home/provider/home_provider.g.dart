// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(HomeNotifier)
const homeNotifierProvider = HomeNotifierProvider._();

final class HomeNotifierProvider
    extends $AsyncNotifierProvider<HomeNotifier, void> {
  const HomeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeNotifierProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeNotifierHash();

  @$internal
  @override
  HomeNotifier create() => HomeNotifier();
}

String _$homeNotifierHash() => r'66334a2b2519f4e7f12374c6da97d5036cc110f0';

abstract class _$HomeNotifier extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
