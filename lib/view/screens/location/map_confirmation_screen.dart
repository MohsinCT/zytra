import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zytranow/controllers/location_provider.dart';
import 'package:zytranow/core/constants/app_constants.dart';
import 'package:zytranow/models/user_address.dart';
import 'package:zytranow/view/widgets/location/map_loading_overlay.dart';

/// Full-screen Google Map screen that lets the user fine-tune their delivery
/// location by dragging the centre pin.
///
/// Key fixes vs the previous version:
///   1. `GoogleMapController` is properly disposed on widget teardown.
///   2. Reverse geocoding uses a debounce timer so rapid camera moves don't
///      fire dozens of network calls.
///   3. Error boundaries prevent a bad geocoding result from crashing the UI.
///   4. `_isMapReady` gate ensures no controller calls happen before the
///      GoogleMap widget has completed initialisation.
class MapConfirmationScreen extends StatefulWidget {
  final UserAddress initialAddress;

  const MapConfirmationScreen({super.key, required this.initialAddress});

  @override
  State<MapConfirmationScreen> createState() => _MapConfirmationScreenState();
}

class _MapConfirmationScreenState extends State<MapConfirmationScreen> {
  // ── Map controller & state ────────────────────────────────────────────────

  GoogleMapController? _mapController; // nullable — assigned in onMapCreated
  bool _isMapReady = false;

  late CameraPosition _initialCameraPosition;
  late UserAddress _currentAddress;
  late LatLng _currentCenter;

  bool _isDragging = false;
  bool _isGeocoding = false;

  /// Debounce timer — started on every onCameraMove, reset if map keeps
  /// moving, fired only when the camera is genuinely idle.
  Timer? _geocodeDebounce;

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _currentAddress = widget.initialAddress;
    _currentCenter = LatLng(_currentAddress.lat, _currentAddress.lng);
    _initialCameraPosition = CameraPosition(
      target: _currentCenter,
      zoom: 16.0,
    );
  }

  @override
  void dispose() {
    // CRITICAL: always dispose the controller. Forgetting this causes a
    // platform-channel leak and a crash when the user rapidly navigates back.
    _geocodeDebounce?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  // ── Map callbacks ─────────────────────────────────────────────────────────

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (mounted) {
      setState(() => _isMapReady = true);
    }
  }

  void _onCameraMove(CameraPosition position) {
    _currentCenter = position.target;

    // Cancel any pending geocode debounce so we don't fire mid-drag.
    _geocodeDebounce?.cancel();

    if (!_isDragging) {
      setState(() => _isDragging = true);
    }
  }

  void _onCameraIdle() {
    setState(() {
      _isDragging = false;
      _isGeocoding = true;
    });

    // Debounce: only fire reverse geocode once the camera has been still
    // for kGeocodeDebounce milliseconds.
    _geocodeDebounce = Timer(kGeocodeDebounce, _reverseGeocodeCenter);
  }

  // ── Geocoding & location ──────────────────────────────────────────────────

  Future<void> _reverseGeocodeCenter() async {
    if (!mounted) return;

    final locationProvider = context.read<LocationProvider>();
    final address = await locationProvider.reverseGeocodeCoordinates(
      _currentCenter.latitude,
      _currentCenter.longitude,
    );

    if (!mounted) return;

    if (address != null) {
      setState(() {
        _currentAddress = address;
        _isGeocoding = false;
      });
    } else {
      setState(() => _isGeocoding = false);
      // Soft error — don't crash; keep showing last known address.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              const Text('Could not get address here. Try a nearby spot.'),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Colors.black87,
          action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
    }
  }

  Future<void> _recenterToLiveLocation() async {
    if (_isGeocoding) return;

    setState(() => _isGeocoding = true);

    final locationProvider = context.read<LocationProvider>();
    final liveAddress = await locationProvider.fetchLiveLocationForMap();

    if (!mounted) return;

    if (liveAddress != null) {
      final target = LatLng(liveAddress.lat, liveAddress.lng);
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: target, zoom: 16.0),
        ),
      );
      setState(() {
        _currentAddress = liveAddress;
        _currentCenter = target;
        _isGeocoding = false;
      });
    } else {
      setState(() => _isGeocoding = false);
      final msg =
          locationProvider.errorMessage ?? 'Failed to get live location.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  // ── Confirm ───────────────────────────────────────────────────────────────

  void _onConfirmPressed() {
    // Navigate to address details screen to collect receiver info before saving.
    Navigator.pushNamed(context, '/address-details', arguments: _currentAddress);
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Full-screen map ──────────────────────────────────────────────
          GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            myLocationEnabled: false,
            compassEnabled: false,
            mapType: MapType.normal,
            liteModeEnabled: false,
            onMapCreated: _onMapCreated,
            onCameraMove: _onCameraMove,
            onCameraIdle: _onCameraIdle,
          ),

          // ── Loading overlay — shown until map is initialised ─────────────
          if (!_isMapReady)
            const MapLoadingOverlay(message: 'Loading map…'),

          // ── Centre pin (only when map is ready) ─────────────────────────
          if (_isMapReady)
            _buildCentrePin(),

          // ── Top bar: back + search row ───────────────────────────────────
          _buildTopBar(context),

          // ── Re-center FAB ────────────────────────────────────────────────
          if (_isMapReady)
            _buildRecenterFab(),

          // ── Bottom confirmation card ─────────────────────────────────────
          _buildBottomCard(context),
        ],
      ),
    );
  }

  // ── Sub-widgets ───────────────────────────────────────────────────────────

  Widget _buildCentrePin() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 36.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutBack,
          transform:
              Matrix4.translationValues(0, _isDragging ? -18.0 : 0.0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Pin head
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: kPrimaryPink,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.5),
                  boxShadow: [
                    BoxShadow(
                      color: kPrimaryPink.withValues(alpha: 0.4),
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.shopping_bag,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              // Pin tip
              CustomPaint(
                size: const Size(12, 6),
                painter: _TrianglePainter(color: kPrimaryPink),
              ),
              const SizedBox(height: 4),
              // Drop shadow beneath pin (shrinks when lifted)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: _isDragging ? 6.0 : 14.0,
                height: 4.0,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withValues(alpha: _isDragging ? 0.08 : 0.25),
                      blurRadius: _isDragging ? 4.0 : 1.5,
                      spreadRadius: _isDragging ? 0.5 : 0.0,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 16,
      right: 16,
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.arrow_back,
                  color: Colors.black87, size: 20),
            ),
          ),
          const SizedBox(width: 12),
          // Search bar (cosmetic — tapping could open a Places search later)
          Expanded(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(kRadiusRound),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Colors.black54, size: 20),
                  SizedBox(width: 12),
                  Text(
                    'Move pin to adjust location',
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
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

  Widget _buildRecenterFab() {
    return Positioned(
      bottom: 275,
      right: 16,
      child: GestureDetector(
        onTap: _isGeocoding ? null : _recenterToLiveLocation,
        child: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: _isGeocoding
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(kPrimaryPink),
                    ),
                  )
                : const Icon(Icons.my_location,
                    color: kPrimaryPink, size: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomCard(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          kSpacingLG,
          kSpacingLG,
          kSpacingLG,
          MediaQuery.of(context).padding.bottom + kSpacingMD,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(kRadiusXL)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 20,
              offset: Offset(0, -6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Delivery label row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: kPrimaryPink.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delivery_dining,
                    color: kPrimaryPink,
                    size: 18,
                  ),
                ),
                const SizedBox(width: kSpacingSM),
                const Text(
                  'Order will be delivered here',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: kSpacingMD),

            // Address area — shimmer placeholders while geocoding
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState: _isGeocoding
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: _buildShimmerPlaceholder(),
              secondChild: _buildAddressText(),
            ),
            const SizedBox(height: kSpacingLG),

            // Confirm button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isGeocoding ? null : _onConfirmPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryPink,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade200,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kRadiusLG),
                  ),
                ),
                child: const Text(
                  'Confirm & proceed',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerPlaceholder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 140,
          height: 22,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: kSpacingSM),
        Container(
          width: double.infinity,
          height: 15,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 220,
          height: 15,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }

  Widget _buildAddressText() {
    final locality = _currentAddress.locality.isNotEmpty
        ? _currentAddress.locality
        : 'Selected Location';

    final address = _currentAddress.fullAddress.isNotEmpty
        ? _currentAddress.fullAddress
        : '${_currentAddress.lat.toStringAsFixed(6)}, '
            '${_currentAddress.lng.toStringAsFixed(6)}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locality,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.2,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Text(
          address,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 13,
            height: 1.45,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

// ─── Custom Painters ──────────────────────────────────────────────────────────

/// Draws the downward-pointing triangular tip of the map pin.
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
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
