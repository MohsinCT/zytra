import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zytranow/controllers/location_provider.dart';
import 'package:zytranow/controllers/address_provider.dart';
import 'package:zytranow/view/screens/profile/profile_screen.dart';
import 'package:zytranow/view/screens/location/select_location_screen.dart';
import 'package:zytranow/core/constants/app_constants.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    const Text(
                      "ZYTRA",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: kPrimaryPink,
                        letterSpacing: -1.0,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "in minutes",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: context.textDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Consumer2<LocationProvider, AddressProvider>(
                  builder: (context, locationProvider, addressProvider, child) {
                    final activeAddress = addressProvider.activeAddress;
                    final savedLoc = locationProvider.savedAddress;

                    String displayText = 'Select Location';
                    if (activeAddress != null) {
                      displayText = '📍 ${activeAddress.address.locality}';
                    } else if (savedLoc != null) {
                      displayText = '📍 ${savedLoc.locality}';
                    }

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SelectLocationScreen(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          if (displayText == 'Select Location') ...[
                            Icon(
                              Icons.location_on,
                              color: context.textDark,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                          ],
                          if (locationProvider.isLoading)
                            Container(
                              width: 80,
                              height: 16,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            )
                          else
                            Text(
                              displayText,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: context.textDark,
                              ),
                            ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: context.textDark,
                            size: 18,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: context.cardBackground,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(
                      context.isDark ? 0.02 : 0.15,
                    ),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.person_outline,
                color: context.textDark,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
