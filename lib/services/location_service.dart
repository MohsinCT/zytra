
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:zytranow/core/constants/app_constants.dart';

/// Low-level location data access layer.
///
/// All platform calls are isolated here so that:
///   - Provider / business logic stays free of platform SDK imports.
///   - This class can be mocked in tests by injecting a fake via constructor.
///   - Timeout and accuracy are tuned for real-device reliability.
class LocationService {
  /// Check if device location services (GPS / network) are enabled.
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Return the current [LocationPermission] status without prompting.
  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  /// Prompt the user for location permission and return the new status.
  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  /// Fetch the current GPS position.
  ///
  /// Uses [LocationSettings] (the non-deprecated API for geolocator ≥ 9.x)
  /// and wraps with [kLocationTimeout] so the call never hangs indefinitely
  /// on real devices with a marginal GPS signal.
  ///
  /// Throws a [TimeoutException] if the device does not respond in time.
  Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        // distanceFilter 0 = report immediately, no distance threshold.
        distanceFilter: 0,
      ),
    ).timeout(
      kLocationTimeout,
      onTimeout: () => throw Exception(
        'Location request timed out after ${kLocationTimeout.inSeconds}s. '
        'Check GPS signal or internet connectivity.',
      ),
    );
  }

  /// Reverse geocode [latitude] / [longitude] into a list of [Placemark]s.
  ///
  /// Returns an empty list (never throws) when no results are available,
  /// keeping error handling in the provider layer where it belongs.
  Future<List<Placemark>> reverseGeocode(
    double latitude,
    double longitude,
  ) async {
    try {
      return await placemarkFromCoordinates(latitude, longitude);
    } catch (_) {
      return [];
    }
  }

  /// Open the device's app-settings page so the user can grant permissions
  /// that have been permanently denied (iOS "Don't Allow" path).
  Future<bool> openAppSettings() async {
    return await Geolocator.openAppSettings();
  }

  /// Open the device location-settings page (to turn GPS on).
  Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }
}
