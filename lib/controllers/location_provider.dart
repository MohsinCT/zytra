import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zytranow/models/user_address.dart';
import 'package:zytranow/services/location_service.dart';

// ─── Permission State Enum ────────────────────────────────────────────────────

/// Fine-grained permission / service state used by the UI to decide
/// which error widget or dialog to show — rather than parsing raw strings.
enum LocationPermissionStatus {
  /// Initial state — not yet checked.
  unknown,

  /// All good; location can be fetched.
  granted,

  /// User tapped "Allow Once" — valid for this session.
  grantedWhileInUse,

  /// Permission denied this session — can re-request.
  denied,

  /// "Don't Allow" tapped twice — must send user to Settings.
  permanentlyDenied,

  /// GPS / location services toggled off in system settings.
  serviceDisabled,
}

// ─── Provider ────────────────────────────────────────────────────────────────

class LocationProvider extends ChangeNotifier {
  final LocationService _locationService;

  // Allow injection for testing; default to a real instance.
  LocationProvider({LocationService? locationService})
    : _locationService = locationService ?? LocationService() {
    loadSavedLocation();
  }

  // ── State Fields ──────────────────────────────────────────────────────────

  bool _isLoading = false;
  UserAddress? _savedAddress;
  String? _errorMessage;
  LocationPermissionStatus _permissionStatus = LocationPermissionStatus.unknown;

  // ── Public Getters ────────────────────────────────────────────────────────

  bool get isLoading => _isLoading;

  /// Display string shown in the home-screen location chip.
  String get currentLocation => _savedAddress?.locality ?? 'Select Location';

  UserAddress? get savedAddress => _savedAddress;

  String? get errorMessage => _errorMessage;

  LocationPermissionStatus get permissionStatus => _permissionStatus;

  /// True when permission is permanently denied — UI should show "Open Settings".
  bool get isPermanentlyDenied =>
      _permissionStatus == LocationPermissionStatus.permanentlyDenied;

  /// True when GPS is off — UI should show "Enable Location Services".
  bool get isServiceDisabled =>
      _permissionStatus == LocationPermissionStatus.serviceDisabled;

  // ── Persistence ───────────────────────────────────────────────────────────

  Future<void> loadSavedLocation() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? addressJson = prefs.getString('saved_user_address');
      if (addressJson != null) {
        _savedAddress = UserAddress.fromJson(jsonDecode(addressJson));
      }
    } catch (e) {
      debugPrint('[LocationProvider] Error loading saved location: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveConfirmedLocation(UserAddress address) async {
    _savedAddress = address;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('saved_user_address', jsonEncode(address.toJson()));
    } catch (e) {
      debugPrint('[LocationProvider] Error persisting location: $e');
    }
  }

  // ── Permission & Location Fetch ───────────────────────────────────────────

  /// Full flow: check services → check/request permission → get GPS →
  /// reverse geocode → return [UserAddress].
  ///
  /// Returns null and populates [errorMessage] + [permissionStatus] on
  /// any failure so the UI can react appropriately without parsing strings.
  Future<UserAddress?> fetchLiveLocationForMap() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. GPS / location services check
      final serviceEnabled = await _locationService.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _permissionStatus = LocationPermissionStatus.serviceDisabled;
        _errorMessage =
            'Location services are disabled. Please enable GPS in Settings.';
        return _fail();
      }

      // 2. Permission check & optional request
      LocationPermission permission = await _locationService.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await _locationService.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        _permissionStatus = LocationPermissionStatus.denied;
        _errorMessage = 'Location permission denied. Please allow access.';
        return _fail();
      }

      if (permission == LocationPermission.deniedForever) {
        _permissionStatus = LocationPermissionStatus.permanentlyDenied;
        _errorMessage =
            'Location permission permanently denied. Open Settings to enable.';
        return _fail();
      }

      _permissionStatus = permission == LocationPermission.whileInUse
          ? LocationPermissionStatus.grantedWhileInUse
          : LocationPermissionStatus.granted;

      // 3. Get current GPS position (with timeout)
      final position = await _locationService.getCurrentPosition();

      // 4. Reverse geocode
      final placemarks = await _locationService.reverseGeocode(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final address = _buildUserAddress(
          placemarks[0],
          position.latitude,
          position.longitude,
          title: 'Current Location',
        );
        _isLoading = false;
        notifyListeners();
        return address;
      } else {
        // Coordinates valid but no placemark — still usable for the map.
        final address = UserAddress(
          title: 'Current Location',
          fullAddress:
              '${position.latitude.toStringAsFixed(5)}, ${position.longitude.toStringAsFixed(5)}',
          locality: 'Current Location',
          lat: position.latitude,
          lng: position.longitude,
        );
        _isLoading = false;
        notifyListeners();
        return address;
      }
    } catch (e) {
      debugPrint('[LocationProvider] fetchLiveLocationForMap error: $e');
      if (e.toString().contains('timed out')) {
        _errorMessage =
            'Could not get GPS position. Check your signal and try again.';
      } else {
        _errorMessage =
            'Failed to fetch location. Check GPS and internet connection.';
      }
    }

    return _fail();
  }

  /// Frontend-only mock for 'Use Current Location' when GPS / APIs are not used.
  /// Returns a deterministic mock address and updates saved address state.
  Future<UserAddress> mockUseCurrentLocation() async {
    // Simulate a small delay as if fetching GPS
    await Future.delayed(const Duration(milliseconds: 400));
    final mock = UserAddress(
      title: 'Current Location',
      fullAddress: 'Poovattuparamba, Kozhikode, Kerala',
      locality: 'Poovattuparamba',
      lat: 11.2858,
      lng: 75.7860,
    );
    // Update saved address immediately
    await saveConfirmedLocation(mock);
    return mock;
  }

  /// Reverse geocodes a [lat]/[lng] pair — called when the map camera settles
  /// after a drag. Does NOT touch [_isLoading] at the provider level to avoid
  /// triggering a full-screen rebuild; the screen manages its own geocoding state.
  Future<UserAddress?> reverseGeocodeCoordinates(double lat, double lng) async {
    try {
      final placemarks = await _locationService.reverseGeocode(lat, lng);
      if (placemarks.isNotEmpty) {
        return _buildUserAddress(
          placemarks[0],
          lat,
          lng,
          title: 'Selected Location',
        );
      }
    } catch (e) {
      debugPrint(
        '[LocationProvider] reverseGeocodeCoordinates error ($lat, $lng): $e',
      );
    }
    return null;
  }

  // ── Settings Navigation ───────────────────────────────────────────────────

  /// Opens the app-level Settings page so the user can grant
  /// permanently-denied location permission.
  Future<void> openAppSettings() async {
    await _locationService.openAppSettings();
  }

  /// Opens the device location-settings page (to turn GPS on).
  Future<void> openLocationSettings() async {
    await _locationService.openLocationSettings();
  }

  // ── Private Helpers ───────────────────────────────────────────────────────

  /// Resets loading state, notifies listeners, and returns null.
  UserAddress? _fail() {
    _isLoading = false;
    notifyListeners();
    return null;
  }

  /// Assembles a [UserAddress] from a geocoding [Placemark].
  UserAddress _buildUserAddress(
    Placemark place,
    double lat,
    double lng, {
    required String title,
  }) {
    final locality = place.locality?.isNotEmpty == true
        ? place.locality!
        : place.subAdministrativeArea?.isNotEmpty == true
        ? place.subAdministrativeArea!
        : place.administrativeArea ?? 'Unknown Location';

    final parts = <String>[
      if (place.street?.isNotEmpty == true) place.street!,
      if (place.subLocality?.isNotEmpty == true) place.subLocality!,
      if (place.locality?.isNotEmpty == true) place.locality!,
      if (place.administrativeArea?.isNotEmpty == true)
        place.administrativeArea!,
      if (place.postalCode?.isNotEmpty == true) place.postalCode!,
      if (place.country?.isNotEmpty == true) place.country!,
    ];

    final fullAddress = parts
        .join(', ')
        .replaceAll(RegExp(r',\s*,'), ',')
        .trim();

    final shortLocality = fullAddress.isNotEmpty
        ? fullAddress.split(',').first.trim()
        : locality;

    return UserAddress(
      title: title,
      fullAddress: fullAddress,
      locality: shortLocality,
      lat: lat,
      lng: lng,
    );
  }
}
