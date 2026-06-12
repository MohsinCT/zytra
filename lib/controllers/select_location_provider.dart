import 'package:flutter/material.dart';
import 'package:zytranow/models/user_address.dart';

class SelectLocationProvider extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  List<String> _suggestions = [];

  final List<String> _knownPlaces = [
    'Vellayil',
    'Poovattuparamba',
    'Valanchery',
    'Kozhikode'
  ];

  final Map<String, UserAddress> _mockCoordinates = {
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

  List<String> get suggestions => _suggestions;
  Map<String, UserAddress> get mockCoordinates => _mockCoordinates;

  SelectLocationProvider() {
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final text = searchController.text.trim();
    if (text.isEmpty) {
      _suggestions = [];
      notifyListeners();
      return;
    }
    final lowercaseText = text.toLowerCase();
    _suggestions = _knownPlaces
        .where((place) => place.toLowerCase().contains(lowercaseText))
        .toList();
    notifyListeners();
  }

  void clearSearch() {
    searchController.clear();
    _suggestions = [];
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }
}
