import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_notifier.g.dart';

@riverpod
class Location extends _$Location {
  @override
  FutureOr<Position?> build() async => getLocation();

  Future<Position?> getLocation() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      // 1. Check Permission Status
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permission denied';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Permission permanently denied. Please enable it in settings.';
      }

      // 2. Check if GPS is actually turned on
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'GPS is turned off. Please enable location services.';
      }

      return await Geolocator.getCurrentPosition();
    });
    return state.value;
  }

  /// New: Helper to open OS Settings if permanently denied
  Future<void> openSettings() async {
    await Geolocator.openAppSettings();
  }
}
