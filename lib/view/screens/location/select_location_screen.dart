import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zytranow/controllers/location_provider.dart';
import 'package:zytranow/controllers/address_provider.dart';
import 'package:zytranow/controllers/user_provider.dart';
import 'package:zytranow/controllers/select_location_provider.dart';
import 'package:zytranow/core/constants/app_constants.dart';
import 'package:zytranow/models/address_entry.dart';
import 'package:zytranow/view/screens/location/map_picker_screen.dart';

class SelectLocationScreen extends StatelessWidget {
  const SelectLocationScreen({super.key});

  Future<void> _handleUseCurrentLocation(BuildContext context) async {
    final locationProvider = context.read<LocationProvider>();
    final addressProvider = context.read<AddressProvider>();
    final userProvider = context.read<UserProvider>();

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Center(
        child: Card(
          color: context.cardBackground,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(kPrimaryPink),
                ),
                const SizedBox(height: 16),
                Text(
                  'Fetching Current Location...',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: context.textDark,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      final realAddress = await locationProvider.fetchLiveLocationForMap();

      if (!context.mounted) return;
      Navigator.pop(context); // Dismiss loading dialog

      if (realAddress != null) {
        // Save in LocationProvider
        await locationProvider.saveConfirmedLocation(realAddress);

        // Save in AddressProvider
        final newId = await addressProvider.addAddress(
          address: realAddress,
          receiverName: userProvider.fullName ?? 'User',
          receiverNumber: userProvider.phoneNumber,
          type: AddressType.home,
        );

        await addressProvider.setActive(newId);

        if (context.mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      } else {
        // Show error message from provider
        final errorMsg =
            locationProvider.errorMessage ??
            'Could not fetch your location. Please check your GPS and permissions.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Dismiss loader if still showing
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to fetch location: ${e.toString()}'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SelectLocationProvider(),
      child: Consumer<SelectLocationProvider>(
        builder: (context, selectLocProvider, child) {
          final suggestions = selectLocProvider.suggestions;

          return Scaffold(
            backgroundColor: context.scaffoldBackground,
            appBar: AppBar(
              backgroundColor: context.scaffoldBackground,
              elevation: 0,
              surfaceTintColor: Colors.transparent,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: context.textDark),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                'Select your location',
                style: TextStyle(
                  color: context.textDark,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: _buildSearchField(selectLocProvider, context),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 12),
                              // Use Current Location Card
                              _buildCurrentLocationTile(context),
                              const SizedBox(height: 14),
                              // Add New Address Card
                              _buildAddNewAddressTile(context),
                              const SizedBox(height: 28),
                              // Saved Addresses
                              Text(
                                'Saved Addresses',
                                style: TextStyle(
                                  color: context.textDark,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildSavedAddressesList(context),
                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                        // Dropdown Suggestions overlay
                        if (suggestions.isNotEmpty)
                          _buildSuggestionsList(context, selectLocProvider),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchField(
    SelectLocationProvider selectLocProvider,
    BuildContext context,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: context.inputFill,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderTheme),
      ),
      child: TextField(
        controller: selectLocProvider.searchController,
        style: TextStyle(
          fontSize: 15,
          color: context.textDark,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: 'Search an area or address',
          hintStyle: TextStyle(color: context.textMuted, fontSize: 14),
          prefixIcon: Icon(Icons.search, color: context.textMuted),
          suffixIcon: selectLocProvider.searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: context.textMuted, size: 18),
                  onPressed: () => selectLocProvider.clearSearch(),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildCurrentLocationTile(BuildContext context) {
    return InkWell(
      onTap: () => _handleUseCurrentLocation(context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kPrimaryPink.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: kPrimaryPink.withValues(alpha: 0.35),
            width: 1.5,
          ),
        ),
        child: const Row(
          children: [
            Icon(Icons.my_location, color: kPrimaryPink, size: 22),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Use Current Location',
                    style: TextStyle(
                      color: kPrimaryPink,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Using GPS to detect your address',
                    style: TextStyle(
                      color: kPrimaryPink,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: kPrimaryPink, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAddNewAddressTile(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MapPickerScreen()),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: context.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.borderTheme),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: context.isDark ? 0.005 : 0.015,
              ),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.add, color: kPrimaryPink, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                'Add New Address',
                style: TextStyle(
                  color: context.textDark,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: context.textMuted, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionsList(
    BuildContext context,
    SelectLocationProvider selectLocProvider,
  ) {
    final suggestions = selectLocProvider.suggestions;

    return Positioned(
      top: 0,
      left: 16,
      right: 16,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 250),
        decoration: BoxDecoration(
          color: context.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.borderTheme),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: context.isDark ? 0.02 : 0.1,
              ),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: suggestions.length,
          itemBuilder: (ctx, index) {
            final suggestion = suggestions[index];
            final selectedAddress =
                selectLocProvider.mockCoordinates[suggestion];
            return ListTile(
              leading: const Icon(
                Icons.location_on_outlined,
                color: kPrimaryPink,
              ),
              title: Text(
                suggestion,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: context.textDark,
                ),
              ),
              subtitle: Text(
                selectedAddress?.fullAddress ?? '',
                style: TextStyle(fontSize: 12, color: context.textMuted),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        MapPickerScreen(initialAddress: selectedAddress),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildSavedAddressesList(BuildContext context) {
    return Consumer<AddressProvider>(
      builder: (context, addressProvider, _) {
        final addresses = addressProvider.addresses;
        final activeAddress = addressProvider.activeAddress;

        if (addresses.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Text(
                'No saved addresses yet',
                style: TextStyle(color: context.textMuted, fontSize: 13),
              ),
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: addresses.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final entry = addresses[index];
            final isSelected = activeAddress?.id == entry.id;

            IconData typeIcon = Icons.home;
            if (entry.type == AddressType.office) {
              typeIcon = Icons.work;
            } else if (entry.type == AddressType.other) {
              typeIcon = Icons.location_on;
            }

            return InkWell(
              onTap: () async {
                final locProvider = Provider.of<LocationProvider>(
                  context,
                  listen: false,
                );
                await addressProvider.setActive(entry.id);
                await locProvider.saveConfirmedLocation(entry.address);

                if (context.mounted) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? kPrimaryPink.withValues(alpha: 0.04)
                      : context.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? kPrimaryPink : context.borderTheme,
                    width: isSelected ? 1.5 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: context.isDark ? 0.005 : 0.01,
                      ),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      typeIcon,
                      color: isSelected ? kPrimaryPink : context.textMuted,
                      size: 24,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                entry.type == AddressType.home
                                    ? 'Home'
                                    : entry.type == AddressType.office
                                    ? 'Office'
                                    : 'Other',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: context.textDark,
                                ),
                              ),
                              if (isSelected) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: kPrimaryPink,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'Selected',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            entry.address.fullAddress,
                            style: TextStyle(
                              color: context.textDark,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Receiver: ${entry.receiverName} (${entry.receiverNumber})',
                            style: TextStyle(
                              color: context.textMuted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: context.textMuted,
                        size: 20,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: context.cardBackground,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            title: Text(
                              'Delete address?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: context.textDark,
                              ),
                            ),
                            content: Text(
                              'Are you sure you want to remove this saved address?',
                              style: TextStyle(color: context.textDark),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(color: context.textMuted),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.shade600,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                ),
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  addressProvider.removeAddress(entry.id);
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
