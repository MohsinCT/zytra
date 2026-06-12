import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:zytranow/controllers/location_provider.dart';
import 'package:zytranow/controllers/map_picker_provider.dart';
import 'package:zytranow/core/constants/app_constants.dart';
import 'package:zytranow/models/user_address.dart';
import 'package:zytranow/view/screens/location/address_details_screen.dart';

class MapPickerScreen extends StatelessWidget {
  final UserAddress? initialAddress;

  const MapPickerScreen({super.key, this.initialAddress});

  void _onConfirm(BuildContext context, MapPickerProvider provider) {
    final confirmedAddress = UserAddress(
      title: provider.selectedLocality,
      fullAddress: provider.fullAddress,
      locality: provider.selectedLocality,
      lat: provider.currentLat,
      lng: provider.currentLng,
    );

    context.read<LocationProvider>().saveConfirmedLocation(confirmedAddress);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddressDetailsScreen(),
        settings: RouteSettings(arguments: confirmedAddress),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MapPickerProvider(initialAddress: initialAddress),
      child: Consumer<MapPickerProvider>(
        builder: (context, provider, child) {
          final isDragging = provider.isDragging;

          return Scaffold(
            backgroundColor: const Color(0xFFF0EFEA),
            body: Stack(
              children: [
                // 1. Fully Realistic Slippy Map tile renderer
                LayoutBuilder(
                  builder: (context, constraints) {
                    return GestureDetector(
                      onPanStart: (_) => provider.setDragging(true),
                      onPanUpdate: (details) => provider.handleDrag(details.delta),
                      onPanEnd: (_) => provider.onDragEnded(),
                      child: ClipRect(
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: const Color(0xFFE4E3DE),
                          child: _buildMapGrid(context, provider, constraints.maxWidth, constraints.maxHeight),
                        ),
                      ),
                    );
                  },
                ),

                // 2. Fixed centered location pin with micro-animations
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 36.0),
                    child: _buildLocationPin(isDragging),
                  ),
                ),

                // 3. Top Floating Search Bar & Back Button
                _buildTopBar(context, provider),

                // 4. Current Location Floating Button
                _buildCurrentLocationFloatingButton(provider),

                // 5. Bottom Confirmation Card
                _buildBottomConfirmationCard(context, provider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMapGrid(BuildContext context, MapPickerProvider provider, double width, double height) {
    // Zoom level is fixed at 15
    const int zoom = 15;
    final double centerXFractional = (provider.currentLng + 180.0) / 360.0 * 32768.0; // 2^15 = 32768
    final double latRad = provider.currentLat * 3.141592653589793 / 180.0;
    final double centerYFractional = (1.0 - (log(tan(latRad) + 1.0 / cos(latRad)) / 3.141592653589793)) / 2.0 * 32768.0;

    final int centerTileX = centerXFractional.floor();
    final int centerTileY = centerYFractional.floor();

    final List<Widget> tiles = [];
    for (int i = -2; i <= 2; i++) {
      for (int j = -2; j <= 2; j++) {
        final int tx = centerTileX + i;
        final int ty = centerTileY + j;

        final double left = width / 2 + (tx - centerXFractional) * 256;
        final double top = height / 2 + (ty - centerYFractional) * 256;

        tiles.add(
          Positioned(
            left: left,
            top: top,
            width: 256,
            height: 256,
            child: CachedNetworkImage(
              imageUrl: 'https://tile.openstreetmap.org/$zoom/$tx/$ty.png',
              fit: BoxFit.fill,
              httpHeaders: const {
                'User-Agent': 'ZytraApp/1.0.0 (flutter prototype; contact development)'
              },
              placeholder: (context, url) => Container(
                color: const Color(0xFFE4E3DE),
                child: Center(
                  child: Icon(Icons.map_outlined, color: Colors.grey.shade400, size: 28),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: const Color(0xFFE4E3DE),
                child: Center(
                  child: Icon(Icons.broken_image_outlined, color: Colors.grey.shade400, size: 24),
                ),
              ),
            ),
          ),
        );
      }
    }

    return Stack(children: tiles);
  }

  Widget _buildLocationPin(bool isDragging) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          transform: Matrix4.translationValues(0, isDragging ? -14 : 0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: kPrimaryPink,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.5),
                  boxShadow: [
                    BoxShadow(
                      color: kPrimaryPink.withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: const Icon(
                  Icons.shopping_bag,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              CustomPaint(
                size: const Size(12, 6),
                painter: _TrianglePainter(color: kPrimaryPink),
              ),
            ],
          ),
        ),
        const SizedBox(height: 3),
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: isDragging ? 6.0 : 14.0,
          height: 3.5,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: isDragging ? 0.08 : 0.25),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar(BuildContext context, MapPickerProvider provider) {
    final suggestions = provider.suggestions;

    return Positioned(
      top: MediaQuery.of(context).padding.top + 12,
      left: 16,
      right: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
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
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: const Icon(Icons.arrow_back, color: kTextDark, size: 20),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: TextField(
                    controller: provider.searchController,
                    style: const TextStyle(fontSize: 14, color: kTextDark, fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      hintText: 'Search an area or address',
                      hintStyle: const TextStyle(color: kTextMuted, fontSize: 13),
                      prefixIcon: const Icon(Icons.search, color: kTextMuted, size: 20),
                      suffixIcon: provider.searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: kTextMuted, size: 16),
                              onPressed: () => provider.searchController.clear(),
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (suggestions.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.only(left: 48),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: suggestions.length,
                itemBuilder: (ctx, index) {
                  final suggestion = suggestions[index];
                  return ListTile(
                    dense: true,
                    leading: const Icon(Icons.location_on_outlined, color: kPrimaryPink, size: 18),
                    title: Text(suggestion, style: const TextStyle(fontWeight: FontWeight.bold, color: kTextDark)),
                    subtitle: Text(
                      provider.mockCoordinates[suggestion]?.fullAddress ?? '',
                      style: const TextStyle(fontSize: 11, color: kTextMuted),
                    ),
                    onTap: () => provider.onSuggestionSelected(suggestion),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCurrentLocationFloatingButton(MapPickerProvider provider) {
    return Positioned(
      bottom: 215,
      right: 16,
      child: GestureDetector(
        onTap: provider.isGeocoding ? null : provider.resetToCurrentLocation,
        child: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Center(
            child: provider.isGeocoding
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(kPrimaryPink),
                    ),
                  )
                : const Icon(Icons.my_location, color: kPrimaryPink, size: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomConfirmationCard(BuildContext context, MapPickerProvider provider) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          18,
          18,
          18,
          MediaQuery.of(context).padding.bottom + 16,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 18,
              offset: Offset(0, -5),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                const SizedBox(width: 8),
                const Text(
                  'Order will be delivered here',
                  style: TextStyle(
                    color: kTextMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 150),
              crossFadeState: provider.isGeocoding ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              firstChild: _buildAddressShimmer(),
              secondChild: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.selectedLocality,
                    style: const TextStyle(
                      color: kTextDark,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    provider.fullAddress,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: provider.isGeocoding ? null : () => _onConfirm(context, provider),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryPink,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Confirm & Proceed',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 120,
          height: 18,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          height: 14,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 200,
          height: 14,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
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
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant _TrianglePainter oldDelegate) => false;
}
