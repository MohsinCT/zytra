import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:zytranow/models/address_entry.dart';
import 'package:zytranow/models/user_address.dart';

class AddressProvider extends ChangeNotifier {
  final List<AddressEntry> _addresses = [];
  String? _activeAddressId;
  bool _isLoading = false;
  String? _errorMessage;

  // Keys for SharedPreferences
  static const _kAddressesKey = 'local_addresses';
  static const _kActiveIdKey = 'local_active_address_id';

  List<AddressEntry> get addresses => List.unmodifiable(_addresses);

  AddressEntry? get activeAddress {
    if (_activeAddressId == null)
      return _addresses.isNotEmpty ? _addresses.first : null;
    try {
      return _addresses.firstWhere((a) => a.id == _activeAddressId);
    } catch (_) {
      return _addresses.isNotEmpty ? _addresses.first : null;
    }
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AddressProvider() {
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_kAddressesKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(jsonString);
        _addresses.clear();
        for (final item in decoded) {
          _addresses.add(
            AddressEntry.fromJson(Map<String, dynamic>.from(item)),
          );
        }
      }

      _activeAddressId = prefs.getString(_kActiveIdKey);
      // If no active id and addresses exist, pick the first
      if (_activeAddressId == null && _addresses.isNotEmpty) {
        _activeAddressId = _addresses.first.id;
      }
    } catch (e) {
      debugPrint('[AddressProvider] Error loading addresses: $e');
      _errorMessage = 'Failed to load addresses';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<String> addAddress({
    required UserAddress address,
    required String receiverName,
    required String receiverNumber,
    required AddressType type,
    Map<String, String>? fields,
    List<String>? imageUrls,
    String? deliveryInstructions,
    String? voiceNoteUrl,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final id = const Uuid().v4();
      final now = DateTime.now();

      final entry = AddressEntry(
        id: id,
        userId: null,
        address: address,
        type: type,
        receiverName: receiverName,
        receiverNumber: receiverNumber,
        fields: fields ?? {},
        imageUrls: imageUrls ?? [],
        deliveryInstructions: deliveryInstructions ?? '',
        voiceNoteUrl: voiceNoteUrl,
        isDefault: _addresses.isEmpty,
        createdAt: now,
      );

      _addresses.insert(0, entry);

      // If this is the first address, set it active.
      if (_activeAddressId == null) {
        _activeAddressId = id;
      }

      await _saveAll();
      return id;
    } catch (e) {
      debugPrint('[AddressProvider] Error adding address: $e');
      _errorMessage = 'Failed to save address';
      return '';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setActive(String id) async {
    try {
      if (!_addresses.any((a) => a.id == id)) return;
      _activeAddressId = id;
      await _saveAll();
      notifyListeners();
    } catch (e) {
      debugPrint('[AddressProvider] Error setting active address: $e');
      _errorMessage = 'Failed to update default address';
      notifyListeners();
    }
  }

  Future<void> removeAddress(String id) async {
    try {
      _addresses.removeWhere((a) => a.id == id);
      if (_activeAddressId == id) {
        _activeAddressId = _addresses.isNotEmpty ? _addresses.first.id : null;
      }
      await _saveAll();
      notifyListeners();
    } catch (e) {
      debugPrint('[AddressProvider] Error removing address: $e');
      _errorMessage = 'Failed to delete address';
      notifyListeners();
    }
  }

  void clear() async {
    _addresses.clear();
    _activeAddressId = null;
    await _saveAll();
    notifyListeners();
  }

  Future<void> _saveAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(_addresses.map((a) => a.toJson()).toList());
      await prefs.setString(_kAddressesKey, encoded);
      if (_activeAddressId != null) {
        await prefs.setString(_kActiveIdKey, _activeAddressId!);
      } else {
        await prefs.remove(_kActiveIdKey);
      }
    } catch (e) {
      debugPrint('[AddressProvider] Error saving addresses: $e');
    }
  }
}
