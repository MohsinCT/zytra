import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationProvider extends ChangeNotifier {
  bool _isLoading = false;
  String _currentLocation = "Select Location";
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String get currentLocation => _currentLocation;
  String? get errorMessage => _errorMessage;

  LocationProvider() {
    fetchLocation();
  }

  Future<void> fetchLocation() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _errorMessage = "Location services are disabled.";
        _isLoading = false;
        notifyListeners();
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _errorMessage = "Location permissions are denied";
          _isLoading = false;
          notifyListeners();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _errorMessage = "Location permissions are permanently denied, we cannot request permissions.";
        _isLoading = false;
        notifyListeners();
        return;
      }

      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        // Priority: locality > subAdministrativeArea > administrativeArea
        _currentLocation = place.locality ?? place.subAdministrativeArea ?? place.administrativeArea ?? "Unknown Location";
      } else {
        _currentLocation = "Unknown Location";
      }

    } catch (e) {
      _errorMessage = "Failed to fetch location";
      _currentLocation = "Select Location";
    }

    _isLoading = false;
    notifyListeners();
  }
}
