import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:zytranow/models/address_entry.dart';
import 'package:zytranow/models/user_address.dart';

class AddressProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<AddressEntry> _addresses = [];
  String? _activeAddressId;
  bool _isLoading = false;
  String? _errorMessage;

  List<AddressEntry> get addresses => List.unmodifiable(_addresses);
  AddressEntry? get activeAddress {
    if (_activeAddressId == null) return _addresses.isNotEmpty ? _addresses.first : null;
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
      final user = _auth.currentUser;
      if (user == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('addresses')
          .orderBy('isDefault', descending: true)
          .orderBy('createdAt', descending: true)
          .get();

      _addresses.clear();
      for (final doc in snapshot.docs) {
        final entry = AddressEntry.fromJson({...doc.data(), 'id': doc.id, 'userId': user.uid});
        _addresses.add(entry);
        if (entry.isDefault) {
          _activeAddressId = entry.id;
        }
      }
    } catch (e) {
      debugPrint('[AddressProvider] Error loading addresses: $e');
      _errorMessage = 'Failed to load addresses';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addAddress({
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
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final id = const Uuid().v4();
      final now = DateTime.now();

      final entry = AddressEntry(
        id: id,
        userId: user.uid,
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

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('addresses')
          .doc(id)
          .set(entry.toJson());

      _addresses.insert(0, entry);
      if (entry.isDefault) {
        _activeAddressId = id;
      }
    } catch (e) {
      debugPrint('[AddressProvider] Error adding address: $e');
      _errorMessage = 'Failed to save address';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> setActive(String id) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final oldDefault = _addresses.cast<AddressEntry?>().firstWhere((a) => a?.isDefault ?? false, orElse: () => null);
      if (oldDefault != null) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('addresses')
            .doc(oldDefault.id)
            .update({'isDefault': false});
      }

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('addresses')
          .doc(id)
          .update({'isDefault': true});

      _activeAddressId = id;
      // Reload to ensure UI reflects correct state
      await _loadAddresses();
    } catch (e) {
      debugPrint('[AddressProvider] Error setting active address: $e');
      _errorMessage = 'Failed to update default address';
      notifyListeners();
    }
  }

  Future<void> removeAddress(String id) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('addresses')
          .doc(id)
          .delete();

      _addresses.removeWhere((a) => a.id == id);
      if (_activeAddressId == id) {
        _activeAddressId = _addresses.isNotEmpty ? _addresses.first.id : null;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('[AddressProvider] Error removing address: $e');
      _errorMessage = 'Failed to delete address';
      notifyListeners();
    }
  }

  void clear() {
    _addresses.clear();
    _activeAddressId = null;
    notifyListeners();
  }
}
