import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:zytranow/models/user_address.dart';

class MapPickerProvider extends ChangeNotifier {
  final UserAddress? initialAddress;

  double _currentLat = 11.2588;
  double _currentLng = 75.7804;
  bool _isDragging = false;
  bool _isGeocoding = false;
  bool _isLoading = false;

  String _selectedLocality = 'Kozhikode Beach';
  String _fullAddress = 'Kozhikode Beach, Kozhikode, Kerala 673032';

  final TextEditingController searchController = TextEditingController();
  List<String> _suggestions = [];
  Timer? _geocodeDebounce;
  Timer? _searchDebounce;

  final List<String> _knownPlaces = [
    'Vellayil',
    'Poovattuparamba',
    'Valanchery',
    'Kozhikode',
  ];

  final Map<String, UserAddress> _mockCoordinates = {
    'Vellayil': UserAddress(
      title: 'Vellayil',
      fullAddress: 'Vellayil Beach Rd, Vellayil, Kozhikode, Kerala 673011',
      locality: 'Vellayil Beach Rd',
      lat: 11.2765,
      lng: 75.7750,
    ),
    'Poovattuparamba': UserAddress(
      title: 'Poovattuparamba',
      fullAddress: 'Poovattuparamba Junction, Kozhikode, Kerala 673008',
      locality: 'Poovattuparamba Junction',
      lat: 11.2858,
      lng: 75.7860,
    ),
    'Valanchery': UserAddress(
      title: 'Valanchery',
      fullAddress: 'Valanchery Town, Malappuram, Kerala 676552',
      locality: 'Valanchery Town',
      lat: 10.7833,
      lng: 76.1500,
    ),
    'Kozhikode': UserAddress(
      title: 'Kozhikode',
      fullAddress: 'Kozhikode Beach, Kozhikode, Kerala 673032',
      locality: 'Kozhikode Beach',
      lat: 11.2588,
      lng: 75.7804,
    ),
  };

  double get currentLat => _currentLat;
  double get currentLng => _currentLng;
  bool get isDragging => _isDragging;
  bool get isGeocoding => _isGeocoding;
  bool get isLoading => _isLoading;
  String get selectedLocality => _selectedLocality;
  String get fullAddress => _fullAddress;
  List<String> get suggestions => _suggestions;
  Map<String, UserAddress> get mockCoordinates => _mockCoordinates;

  MapPickerProvider({this.initialAddress}) {
    searchController.addListener(_onSearchChanged);

    if (initialAddress != null) {
      _currentLat = initialAddress!.lat;
      _currentLng = initialAddress!.lng;
      _selectedLocality = initialAddress!.locality;
      _fullAddress = initialAddress!.fullAddress;
    }
  }

  void _onSearchChanged() {
    final text = searchController.text.trim();
    if (text.isEmpty) {
      _suggestions = [];
      _isLoading = false;
      notifyListeners();
      return;
    }

    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 600), () async {
      _isLoading = true;
      notifyListeners();

      try {
        final biasLocality = _selectedLocality.isNotEmpty ? _selectedLocality : 'Kozhikode';
        final localQuery = "$text, $biasLocality";
        final globalQuery = text;

        // Perform lookups in parallel
        final results = await Future.wait([
          locationFromAddress(localQuery).catchError((_) => <Location>[]),
          locationFromAddress(globalQuery).catchError((_) => <Location>[]),
        ]);

        final List<Location> localLocations = results[0];
        final List<Location> globalLocations = results[1];

        // Merge: local locations first, avoid duplicates
        final List<Location> locations = [...localLocations];
        for (final gLoc in globalLocations) {
          bool isDuplicate = false;
          for (final lLoc in localLocations) {
            if ((gLoc.latitude - lLoc.latitude).abs() < 0.005 &&
                (gLoc.longitude - lLoc.longitude).abs() < 0.005) {
              isDuplicate = true;
              break;
            }
          }
          if (!isDuplicate) {
            locations.add(gLoc);
          }
        }

        final Map<String, UserAddress> newMatches = {};
        final List<String> newSuggestions = [];

        final limit = locations.length > 4 ? 4 : locations.length;
        for (int i = 0; i < limit; i++) {
          final loc = locations[i];
          try {
            final placemarks = await placemarkFromCoordinates(loc.latitude, loc.longitude);
            if (placemarks.isNotEmpty) {
              final pm = placemarks.first;
              
              final title = pm.name?.isNotEmpty == true
                  ? pm.name!
                  : (pm.locality?.isNotEmpty == true
                      ? pm.locality!
                      : text);

              final fullAddressParts = <String>[
                if (pm.name?.isNotEmpty == true) pm.name!,
                if (pm.street?.isNotEmpty == true && pm.street != pm.name) pm.street!,
                if (pm.subLocality?.isNotEmpty == true) pm.subLocality!,
                if (pm.locality?.isNotEmpty == true) pm.locality!,
                if (pm.subAdministrativeArea?.isNotEmpty == true) pm.subAdministrativeArea!,
                if (pm.administrativeArea?.isNotEmpty == true) pm.administrativeArea!,
                if (pm.postalCode?.isNotEmpty == true) pm.postalCode!,
                if (pm.country?.isNotEmpty == true) pm.country!,
              ];

              final fullAddress = fullAddressParts.join(', ').replaceAll(RegExp(r',\s*,'), ',').trim();
              final locality = pm.locality?.isNotEmpty == true ? pm.locality! : title;

              String suggestionKey = title;
              int suffix = 1;
              while (newSuggestions.contains(suggestionKey)) {
                suggestionKey = '$title ($suffix)';
                suffix++;
              }

              newSuggestions.add(suggestionKey);
              newMatches[suggestionKey] = UserAddress(
                title: title,
                fullAddress: fullAddress,
                locality: locality,
                lat: loc.latitude,
                lng: loc.longitude,
              );
            }
          } catch (_) {}
        }

        _suggestions = newSuggestions;
        _mockCoordinates.addAll(newMatches);
      } catch (e) {
        debugPrint('Dynamic geocoding in MapPicker failed: $e');
        _loadFallbackSuggestions(text);
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    });
  }

  void _loadFallbackSuggestions(String text) {
    final lowercaseText = text.toLowerCase();
    _suggestions = _knownPlaces
        .where((place) => place.toLowerCase().contains(lowercaseText))
        .toList();
  }

  void onSuggestionSelected(String placeName) {
    final coords = _mockCoordinates[placeName];
    if (coords == null) return;

    _currentLat = coords.lat;
    _currentLng = coords.lng;
    _selectedLocality = coords.locality;
    _fullAddress = coords.fullAddress;
    _suggestions = [];
    searchController.text = placeName;
    notifyListeners();
  }

  void setDragging(bool dragging) {
    _isDragging = dragging;
    notifyListeners();
  }

  void handleDrag(Offset delta) {
    final double centerXFractional = _lonToTileXFractional(_currentLng, 15);
    final double centerYFractional = _latToTileYFractional(_currentLat, 15);

    final double newCenterX = centerXFractional - (delta.dx / 256.0);
    final double newCenterY = centerYFractional - (delta.dy / 256.0);

    _currentLng = _tileXToLon(newCenterX, 15);
    _currentLat = _tileYToLat(newCenterY, 15);
    notifyListeners();
  }

  void onDragEnded() {
    _isDragging = false;
    notifyListeners();

    _geocodeDebounce?.cancel();
    _geocodeDebounce = Timer(
      const Duration(milliseconds: 600),
      reverseGeocodeCenter,
    );
  }

  Future<void> reverseGeocodeCenter() async {
    _isGeocoding = true;
    notifyListeners();

    try {
      final placemarks = await placemarkFromCoordinates(
        _currentLat,
        _currentLng,
      );
      if (placemarks.isNotEmpty) {
        final place = placemarks[0];
        final localityName = place.locality?.isNotEmpty == true
            ? place.locality!
            : (place.subAdministrativeArea?.isNotEmpty == true
                  ? place.subAdministrativeArea!
                  : (place.administrativeArea ?? 'Unknown'));

        final parts = <String>[
          if (place.name?.isNotEmpty == true && place.name != place.street)
            place.name!,
          if (place.street?.isNotEmpty == true) place.street!,
          if (place.subLocality?.isNotEmpty == true) place.subLocality!,
          if (place.locality?.isNotEmpty == true) place.locality!,
          if (place.administrativeArea?.isNotEmpty == true)
            place.administrativeArea!,
          if (place.postalCode?.isNotEmpty == true) place.postalCode!,
        ];

        _fullAddress = parts
            .join(', ')
            .replaceAll(RegExp(r',\s*,'), ',')
            .trim();
        _selectedLocality = _fullAddress.isNotEmpty
            ? _fullAddress.split(',').first.trim()
            : localityName;
      }
    } catch (e) {
      debugPrint('Real geocoding failed, using local lookup fallback: $e');
      _fallbackLocalLookup();
    } finally {
      _isGeocoding = false;
      notifyListeners();
    }
  }

  void _fallbackLocalLookup() {
    double minDistance = double.maxFinite;
    String closest = 'Kozhikode';

    _mockCoordinates.forEach((name, addr) {
      final d =
          (addr.lat - _currentLat) * (addr.lat - _currentLat) +
          (addr.lng - _currentLng) * (addr.lng - _currentLng);
      if (d < minDistance) {
        minDistance = d;
        closest = name;
      }
    });

    final block = ((_currentLng * 1000).abs() % 12).toInt() + 1;
    final streetNum = ((_currentLat * 1000).abs() % 8).toInt() + 1;
    final pincodeSuffix = ((_currentLat * 10000).abs() % 90 + 10).toInt();

    _fullAddress =
        'Block $block, Street $streetNum, $closest, Calicut, Kerala 6730$pincodeSuffix';
    _selectedLocality = 'Block $block, Street $streetNum';
  }

  void resetToCurrentLocation() {
    _isGeocoding = true;
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 500), () {
      final coords = _mockCoordinates['Poovattuparamba']!;
      _currentLat = coords.lat;
      _currentLng = coords.lng;
      _selectedLocality = coords.locality;
      _fullAddress = coords.fullAddress;
      _isGeocoding = false;
      searchController.clear();
      notifyListeners();
    });
  }

  // Mercator projections
  double _lonToTileXFractional(double lon, int zoom) =>
      (lon + 180.0) / 360.0 * pow(2.0, zoom);
  double _latToTileYFractional(double lat, int zoom) {
    final latRad = lat * pi / 180.0;
    return (1.0 - log(tan(latRad) + 1.0 / cos(latRad)) / pi) /
        2.0 *
        pow(2.0, zoom);
  }

  double _tileXToLon(double x, int zoom) => x / pow(2.0, zoom) * 360.0 - 180.0;
  double _tileYToLat(double y, int zoom) {
    final n = pi - 2.0 * pi * y / pow(2.0, zoom);
    return 180.0 / pi * atan(0.5 * (exp(n) - exp(-n)));
  }

  @override
  void dispose() {
    _geocodeDebounce?.cancel();
    _searchDebounce?.cancel();
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }
}
