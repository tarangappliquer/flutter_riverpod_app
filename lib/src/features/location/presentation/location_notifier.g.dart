// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Location)
final locationProvider = LocationProvider._();

final class LocationProvider
    extends $AsyncNotifierProvider<Location, Position?> {
  LocationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'locationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$locationHash();

  @$internal
  @override
  Location create() => Location();
}

String _$locationHash() => r'489d8e954de98799fe30c1b222d2cf3cbd1435da';

abstract class _$Location extends $AsyncNotifier<Position?> {
  FutureOr<Position?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Position?>, Position?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Position?>, Position?>,
              AsyncValue<Position?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
