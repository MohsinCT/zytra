import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zytranow/controllers/location_provider.dart';
import 'package:zytranow/view/screens/profile/profile_screen.dart';
import 'package:zytranow/view/screens/location/select_location_screen.dart';

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
                  children: const [
                    Text(
                      "ZYTRA",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFFF2D6F),
                        letterSpacing: -1.0,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "in minutes",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Consumer<LocationProvider>(
                  builder: (context, locationProvider, child) {
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
                          const Icon(
                            Icons.location_on,
                            color: Colors.black87,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
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
                              locationProvider.currentLocation,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.black87,
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
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.person_outline,
                color: Colors.black87,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
