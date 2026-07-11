import 'package:flutter/material.dart';
import 'dart:async';
import 'package:geocoding/geocoding.dart';
import 'package:zytranow/models/user_address.dart';

class SelectLocationProvider extends ChangeNotifier {
  final String? currentLocality;
  final TextEditingController searchController = TextEditingController();
  List<String> _suggestions = [];
  bool _isLoading = false;
  Timer? _debounceTimer;

  final Map<String, UserAddress> _mockCoordinates = {};

  List<String> get suggestions => _suggestions;
  bool get isLoading => _isLoading;
  Map<String, UserAddress> get mockCoordinates => _mockCoordinates;

  SelectLocationProvider({this.currentLocality}) {
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final text = searchController.text.trim();
    if (text.isEmpty) {
      _suggestions = [];
      _isLoading = false;
      notifyListeners();
      return;
    }

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 600), () async {
      _isLoading = true;
      notifyListeners();

      try {
        final biasLocality = currentLocality?.isNotEmpty == true ? currentLocality! : 'Kozhikode';
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

        // Geocode the top 4 matches to construct rich user addresses
        final limit = locations.length > 4 ? 4 : locations.length;
        for (int i = 0; i < limit; i++) {
          final loc = locations[i];
          try {
            final placemarks = await placemarkFromCoordinates(loc.latitude, loc.longitude);
            if (placemarks.isNotEmpty) {
              final pm = placemarks.first;
              
              // Construct a readable title
              final title = pm.name?.isNotEmpty == true
                  ? pm.name!
                  : (pm.locality?.isNotEmpty == true
                      ? pm.locality!
                      : text);

              // Construct a full address
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

              // Ensure the suggestion key is unique
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
          } catch (_) {
            // Ignore single reverse-geocoding failures
          }
        }

        _suggestions = newSuggestions;
        _mockCoordinates.addAll(newMatches);
      } catch (e) {
        debugPrint('Dynamic geocoding search failed, using fallbacks: $e');
        _loadFallbackSuggestions(text);
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    });
  }

  void _loadFallbackSuggestions(String text) {
    final lowercaseText = text.toLowerCase();
    final List<String> fallbackKnownPlaces = [
      'Vellayil',
      'Poovattuparamba',
      'Valanchery',
      'Kozhikode',
    ];
    final Map<String, UserAddress> fallbackMockMap = {
      'Vellayil': UserAddress(
        title: 'Vellayil',
        fullAddress: 'Vellayil Beach Rd, Vellayil, Kozhikode, Kerala 673011',
        locality: 'Vellayil',
        lat: 11.2765,
        lng: 75.7750,
      ),
      'Poovattuparamba': UserAddress(
        title: 'Poovattuparamba',
        fullAddress: 'Poovattuparamba Junction, Kozhikode, Kerala 673008',
        locality: 'Poovattuparamba',
        lat: 11.2858,
        lng: 75.7860,
      ),
      'Valanchery': UserAddress(
        title: 'Valanchery',
        fullAddress: 'Valanchery Town, Malappuram, Kerala 676552',
        locality: 'Valanchery',
        lat: 10.7833,
        lng: 76.1500,
      ),
      'Kozhikode': UserAddress(
        title: 'Kozhikode',
        fullAddress: 'Kozhikode Beach, Kozhikode, Kerala 673032',
        locality: 'Kozhikode',
        lat: 11.2588,
        lng: 75.7804,
      ),
    };

    _suggestions = fallbackKnownPlaces
        .where((place) => place.toLowerCase().contains(lowercaseText))
        .toList();
    _mockCoordinates.addAll(fallbackMockMap);
  }

  void clearSearch() {
    searchController.clear();
    _suggestions = [];
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }
}
