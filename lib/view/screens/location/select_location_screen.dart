import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zytranow/controllers/location_provider.dart';
import 'package:zytranow/core/constants/app_constants.dart';
import 'package:zytranow/view/screens/location/map_confirmation_screen.dart';
import 'package:zytranow/view/widgets/location/map_loading_overlay.dart';


/// Location selection screen.
///
/// Improvements over the previous version:
///   - Full-screen loading overlay while GPS fetch is in progress.
///   - Actionable dialogs for permanently-denied permission and GPS-off states.
///   - "Use Current Location" is fully disabled (not just visually) while loading.
///   - Clean separation of error states via [LocationPermissionStatus] enum.
class SelectLocationScreen extends StatefulWidget {
  const SelectLocationScreen({super.key});

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ── Tap handler for "Use Current Location" ────────────────────────────────

  Future<void> _handleUseCurrentLocation(BuildContext context) async {
    final locationProvider = context.read<LocationProvider>();
    final userAddress = await locationProvider.fetchLiveLocationForMap();

    if (!context.mounted) return;

    if (userAddress != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              MapConfirmationScreen(initialAddress: userAddress),
        ),
      );
      return;
    }

    // fetchLiveLocationForMap returned null — inspect why and react.
    if (locationProvider.isPermanentlyDenied) {
      _showPermanentlyDeniedDialog(context, locationProvider);
    } else if (locationProvider.isServiceDisabled) {
      _showServiceDisabledDialog(context, locationProvider);
    } else if (locationProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(locationProvider.errorMessage!),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Colors.black87,
        ),
      );
    }
  }

  // ── Error dialogs ─────────────────────────────────────────────────────────

  void _showPermanentlyDeniedDialog(
    BuildContext context,
    LocationProvider provider,
  ) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(kRadiusLG)),
        icon: const Icon(Icons.location_off_rounded,
            color: kPrimaryPink, size: 36),
        title: const Text(
          'Location Access Denied',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: const Text(
          'Zytra needs location access to find stores near you.\n\n'
          'Please tap "Open Settings" and enable Location for Zytra.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, height: 1.55, color: Colors.black54),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.black45)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              provider.openAppSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryPink,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kRadiusMD)),
            ),
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _showServiceDisabledDialog(
    BuildContext context,
    LocationProvider provider,
  ) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(kRadiusLG)),
        icon: const Icon(Icons.gps_off_rounded, color: kPrimaryPink, size: 36),
        title: const Text(
          'GPS is Turned Off',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: const Text(
          'Please enable Location Services on your device so Zytra can '
          'find your delivery address.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, height: 1.55, color: Colors.black54),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.black45)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              provider.openLocationSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryPink,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kRadiusMD)),
            ),
            child: const Text('Enable GPS'),
          ),
        ],
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
      builder: (context, provider, _) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                surfaceTintColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black87),
                  onPressed: () => Navigator.pop(context),
                ),
                title: const Text(
                  'Select your location',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: kSpacingMD),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: kSpacingSM),

                    // ── Search field ────────────────────────────────────────
                    _buildSearchField(),
                    const SizedBox(height: kSpacingLG),

                    // ── Use Current Location ────────────────────────────────
                    _buildCurrentLocationTile(context, provider),
                    const SizedBox(height: kSpacingMD),

                    // ── Add New Address ─────────────────────────────────────
                    _buildAddNewAddressTile(),
                    const SizedBox(height: kSpacingXL),

                    // ── Saved Addresses ─────────────────────────────────────
                    const Text(
                      'Saved Addresses',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: kSpacingSM),
                    _buildSavedAddresses(provider),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            // ── Full-screen loading overlay while fetching GPS ────────────
            if (provider.isLoading)
              const MapLoadingOverlay(message: 'Fetching your location…'),
          ],
        );
      },
    );
  }

  // ── Sub-widgets ───────────────────────────────────────────────────────────

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(kRadiusMD),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: _searchController,
        decoration: const InputDecoration(
          hintText: 'Search an area or address',
          hintStyle: TextStyle(color: Colors.black45, fontSize: 14),
          prefixIcon: Icon(Icons.search, color: Colors.black54),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildCurrentLocationTile(
    BuildContext context,
    LocationProvider provider,
  ) {
    return InkWell(
      // Disabled during any loading — absorbs taps completely.
      onTap: provider.isLoading
          ? null
          : () => _handleUseCurrentLocation(context),
      borderRadius: BorderRadius.circular(kRadiusMD),
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: kSpacingMD, horizontal: kSpacingMD),
        decoration: BoxDecoration(
          color: kPrimaryPink.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(kRadiusMD),
          border: Border.all(color: kPrimaryPink.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.my_location, color: kPrimaryPink),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Use Current Location',
                    style: TextStyle(
                      color: kPrimaryPink,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Using GPS to detect your address',
                    style: TextStyle(
                      color: kPrimaryPink.withValues(alpha: 0.65),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: kPrimaryPink),
          ],
        ),
      ),
    );
  }

  Widget _buildAddNewAddressTile() {
    return InkWell(
      onTap: () {
        // TODO: Implement manual address entry / Places search.
      },
      borderRadius: BorderRadius.circular(kRadiusMD),
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: kSpacingMD, horizontal: kSpacingMD),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(kRadiusMD),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            const Icon(Icons.add, color: Colors.black87),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Add New Address',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black54),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedAddresses(LocationProvider provider) {
    final saved = provider.savedAddress;
    if (saved != null) {
      return _buildSavedAddressCard(
        title: saved.title.isNotEmpty ? saved.title : 'Home',
        address: saved.fullAddress,
        isSelected: true,
      );
    }

    // Dummy placeholders when no address is saved yet.
    return Column(
      children: [
        _buildSavedAddressCard(
          title: 'Home',
          address: '123 Main St, Apartment 4B, San Francisco, CA 94105',
          isSelected: false,
        ),
        const SizedBox(height: 12),
        _buildSavedAddressCard(
          title: 'Work',
          address: '456 Market St, Suite 100, San Francisco, CA 94104',
          isSelected: false,
        ),
      ],
    );
  }

  Widget _buildSavedAddressCard({
    required String title,
    required String address,
    required bool isSelected,
  }) {
    final icon = title.toLowerCase() == 'home'
        ? Icons.home
        : title.toLowerCase() == 'work'
            ? Icons.work
            : Icons.location_on;

    return Container(
      padding: const EdgeInsets.all(kSpacingMD),
      decoration: BoxDecoration(
        color: isSelected ? kPrimaryPink.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(kRadiusMD),
        border: Border.all(
          color: isSelected ? kPrimaryPink : Colors.grey.shade200,
          width: isSelected ? 1.5 : 1.0,
        ),
        boxShadow: isSelected
            ? []
            : [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: isSelected ? kPrimaryPink : Colors.black54,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    if (isSelected) ...[
                      const SizedBox(width: kSpacingSM),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: kPrimaryPink,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Selected',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  address,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: kSpacingSM),
          const Icon(Icons.more_vert, color: Colors.black45, size: 20),
        ],
      ),
    );
  }
}
