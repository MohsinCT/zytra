import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:zytranow/models/user_address.dart';
import 'package:zytranow/core/constants/app_constants.dart';

/// Real Google Maps location picker with draggable center pin and reverse geocoding.
class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  GoogleMapController? _mapController;
  bool _isMapReady = false;
  bool _isGeocoding = false;

  late CameraPosition _initialCameraPosition;
  late LatLng _currentCenter;

  String _selectedLocality = 'Loading...';
  String _fullAddress = 'Loading...';

  Timer? _geocodeDebounce;

  @override
  void initState() {
    super.initState();
    _currentCenter = const LatLng(11.2858, 75.7860); // Default to Kerala
    _initialCameraPosition = CameraPosition(target: _currentCenter, zoom: 16.0);
    _loadCurrentLocation();
  }

  Future<void> _loadCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      if (mounted) {
        setState(() {
          _currentCenter = LatLng(position.latitude, position.longitude);
          _initialCameraPosition = CameraPosition(target: _currentCenter, zoom: 16.0);
        });
        _mapController?.animateCamera(CameraUpdate.newCameraPosition(_initialCameraPosition));
        await _reverseGeocodeCenter();
      }
    } catch (e) {
      debugPrint('Error loading current location: $e');
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    setState(() => _isMapReady = true);
    _reverseGeocodeCenter();
  }

  void _onCameraMove(CameraPosition position) {
    _currentCenter = position.target;
    _geocodeDebounce?.cancel();
  }

  void _onCameraIdle() {
    _geocodeDebounce = Timer(const Duration(milliseconds: 500), _reverseGeocodeCenter);
  }

  Future<void> _reverseGeocodeCenter() async {
    setState(() => _isGeocoding = true);

    try {
      final placemarks = await placemarkFromCoordinates(_currentCenter.latitude, _currentCenter.longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks[0];
        final locality = place.locality?.isNotEmpty == true ? place.locality! : (place.administrativeArea ?? 'Unknown');
        final fullAddress = '${place.thoroughfare ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}'.replaceAll(RegExp(r',\s*,'), ',').trim();

        setState(() {
          _selectedLocality = locality;
          _fullAddress = fullAddress.isEmpty ? 'Coordinates: ${_currentCenter.latitude.toStringAsFixed(4)}, ${_currentCenter.longitude.toStringAsFixed(4)}' : fullAddress;
        });
      }
    } catch (e) {
      debugPrint('Geocoding error: $e');
    }

    setState(() => _isGeocoding = false);
  }

  void _onConfirm() {
    final address = UserAddress(
      title: 'Selected Location',
      fullAddress: _fullAddress,
      locality: _selectedLocality,
      lat: _currentCenter.latitude,
      lng: _currentCenter.longitude,
    );
    Navigator.pushNamed(context, '/address-details', arguments: address);
  }

  @override
  void dispose() {
    _geocodeDebounce?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (_isMapReady)
            GoogleMap(
              initialCameraPosition: _initialCameraPosition,
              onMapCreated: _onMapCreated,
              onCameraMove: _onCameraMove,
              onCameraIdle: _onCameraIdle,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              compassEnabled: false,
            ),
          if (!_isMapReady) const Center(child: CircularProgressIndicator()),

          // Center pin
          if (_isMapReady)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: kPrimaryPink,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: kPrimaryPink.withValues(alpha: 0.4), blurRadius: 10)],
                    ),
                    child: const Icon(Icons.location_on, color: Colors.white, size: 24),
                  ),
                  CustomPaint(size: const Size(12, 8), painter: _TrianglePainter(color: kPrimaryPink)),
                ],
              ),
            ),

          // Top bar
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            right: 16,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 10)]),
                    child: const Icon(Icons.arrow_back, color: Colors.black87, size: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(kRadiusRound), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 10)]),
                    child: const Row(
                      children: [
                        Icon(Icons.search, color: Colors.black54, size: 20),
                        SizedBox(width: 12),
                        Text('Move pin to adjust', style: TextStyle(color: Colors.black45, fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom card
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).padding.bottom + 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(kRadiusXL)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -6))],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isGeocoding)
                    const SizedBox(height: 40, child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))))
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_selectedLocality, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text(_fullAddress, style: TextStyle(color: Colors.grey.shade600, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isGeocoding ? null : _onConfirm,
                      style: ElevatedButton.styleFrom(backgroundColor: kPrimaryPink),
                      child: const Text('Confirm & proceed', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  const _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      Path()
        ..moveTo(0, 0)
        ..lineTo(size.width / 2, size.height)
        ..lineTo(size.width, 0)
        ..close(),
      Paint()..color = color..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
