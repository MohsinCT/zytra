class UserAddress {
  final String title;
  final String fullAddress;
  final String locality;
  final double lat;
  final double lng;

  UserAddress({
    required this.title,
    required this.fullAddress,
    required this.locality,
    required this.lat,
    required this.lng,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'fullAddress': fullAddress,
      'locality': locality,
      'lat': lat,
      'lng': lng,
    };
  }

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    return UserAddress(
      title: json['title'] ?? '',
      fullAddress: json['fullAddress'] ?? '',
      locality: json['locality'] ?? '',
      lat: json['lat']?.toDouble() ?? 0.0,
      lng: json['lng']?.toDouble() ?? 0.0,
    );
  }
}
