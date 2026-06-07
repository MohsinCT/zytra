import 'package:zytranow/models/user_address.dart';

enum AddressType { home, office, other }

class AddressEntry {
  final String id;
  final String? userId; // Firebase user ID
  final UserAddress address;
  final AddressType type;
  final String receiverName;
  final String receiverNumber;
  final Map<String, String> fields; // type-specific fields
  final List<String> imageUrls; // Firestore URLs
  final String deliveryInstructions;
  final String? voiceNoteUrl;
  final bool isDefault;
  final DateTime? createdAt;

  AddressEntry({
    required this.id,
    this.userId,
    required this.address,
    required this.type,
    required this.receiverName,
    required this.receiverNumber,
    this.fields = const {},
    this.imageUrls = const [],
    this.deliveryInstructions = '',
    this.voiceNoteUrl,
    this.isDefault = false,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'address': address.toJson(),
      'type': type.toString(),
      'receiverName': receiverName,
      'receiverNumber': receiverNumber,
      'fields': fields,
      'imageUrls': imageUrls,
      'deliveryInstructions': deliveryInstructions,
      'voiceNoteUrl': voiceNoteUrl,
      'isDefault': isDefault,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory AddressEntry.fromJson(Map<String, dynamic> json) {
    return AddressEntry(
      id: json['id'] ?? '',
      userId: json['userId'],
      address: UserAddress.fromJson(Map<String, dynamic>.from(json['address'] ?? {})),
      type: AddressType.values.firstWhere((e) => e.toString() == (json['type'] ?? AddressType.other.toString()), orElse: () => AddressType.other),
      receiverName: json['receiverName'] ?? '',
      receiverNumber: json['receiverNumber'] ?? '',
      fields: Map<String, String>.from(json['fields'] ?? {}),
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      deliveryInstructions: json['deliveryInstructions'] ?? '',
      voiceNoteUrl: json['voiceNoteUrl'],
      isDefault: json['isDefault'] ?? false,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }
}
