// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SelectedProvince)
final selectedProvinceProvider = SelectedProvinceProvider._();

final class SelectedProvinceProvider
    extends $NotifierProvider<SelectedProvince, String?> {
  SelectedProvinceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedProvinceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedProvinceHash();

  @$internal
  @override
  SelectedProvince create() => SelectedProvince();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$selectedProvinceHash() => r'b862b01f61b48c8fd27990eb1f6554f2f018cbea';

abstract class _$SelectedProvince extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(MapTileStyleState)
final mapTileStyleStateProvider = MapTileStyleStateProvider._();

final class MapTileStyleStateProvider
    extends $NotifierProvider<MapTileStyleState, MapTileStyle> {
  MapTileStyleStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mapTileStyleStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mapTileStyleStateHash();

  @$internal
  @override
  MapTileStyleState create() => MapTileStyleState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MapTileStyle value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MapTileStyle>(value),
    );
  }
}

String _$mapTileStyleStateHash() => r'1afa00bf83ab49d4f2d077e6772398e653c9a5eb';

abstract class _$MapTileStyleState extends $Notifier<MapTileStyle> {
  MapTileStyle build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<MapTileStyle, MapTileStyle>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MapTileStyle, MapTileStyle>,
              MapTileStyle,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(ShowBordersState)
final showBordersStateProvider = ShowBordersStateProvider._();

final class ShowBordersStateProvider
    extends $NotifierProvider<ShowBordersState, bool> {
  ShowBordersStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'showBordersStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$showBordersStateHash();

  @$internal
  @override
  ShowBordersState create() => ShowBordersState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$showBordersStateHash() => r'cbbaffa1876b2ce2335a97d1bbf0449850dc1313';

abstract class _$ShowBordersState extends $Notifier<bool> {
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

@ProviderFor(ShowHeatmapState)
final showHeatmapStateProvider = ShowHeatmapStateProvider._();

final class ShowHeatmapStateProvider
    extends $NotifierProvider<ShowHeatmapState, bool> {
  ShowHeatmapStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'showHeatmapStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$showHeatmapStateHash();

  @$internal
  @override
  ShowHeatmapState create() => ShowHeatmapState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$showHeatmapStateHash() => r'a248bc0ef2b50349a64c06230f86c0f252efd787';

abstract class _$ShowHeatmapState extends $Notifier<bool> {
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

@ProviderFor(MapControllerState)
final mapControllerStateProvider = MapControllerStateProvider._();

final class MapControllerStateProvider
    extends $NotifierProvider<MapControllerState, MapController> {
  MapControllerStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mapControllerStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mapControllerStateHash();

  @$internal
  @override
  MapControllerState create() => MapControllerState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MapController value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MapController>(value),
    );
  }
}

String _$mapControllerStateHash() =>
    r'c0bd3dddf1e158f9723cba3f1504de51d33030f6';

abstract class _$MapControllerState extends $Notifier<MapController> {
  MapController build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<MapController, MapController>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MapController, MapController>,
              MapController,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
