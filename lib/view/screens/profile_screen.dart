import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zytranow/controller/home_provider.dart';
import 'package:zytranow/controller/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light grey background
      body: CustomScrollView(
        slivers: [
          const ProfileHeader(),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height * 0.025),
                  const QuickActionsSection(),
                  SizedBox(height: height * 0.03),
                  const SettingsCardsSection(),
                  SizedBox(height: height * 0.04),

                  const SectionTitle(title: "YOUR INFORMATION"),
                  SizedBox(height: height * 0.015),
                  const InformationList(),

                  SizedBox(height: height * 0.04),
                  const SectionTitle(title: "PAYMENTS & COUPONS"),
                  SizedBox(height: height * 0.015),
                  const PaymentsCouponsList(),

                  SizedBox(height: height * 0.04),
                  const SectionTitle(title: "OTHER INFORMATION"),
                  SizedBox(height: height * 0.015),
                  const OtherInformationList(),

                  SizedBox(height: height * 0.06),
                  const ProfileFooter(),
                  SizedBox(height: height * 0.08),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final topPadding = MediaQuery.of(context).padding.top;

    return SliverToBoxAdapter(
      child: Container(
        color: const Color(0xFF1C1C1E), // Dark header background
        padding: EdgeInsets.only(
          top: topPadding + (height * 0.01),
          left: width * 0.04,
          right: width * 0.04,
          bottom: height * 0.035,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(width * 0.02),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: width * 0.01),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: width * 0.045,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "Profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: width * 0.085,
                ), // Balance the back button for exact centering
              ],
            ),
            SizedBox(height: height * 0.035),
            Text(
              "Mohsin",
              style: TextStyle(
                color: Colors.white,
                fontSize: width * 0.08,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: height * 0.012),
            Row(
              children: [
                Icon(
                  Icons.phone_outlined,
                  color: Colors.white70,
                  size: width * 0.04,
                ),
                SizedBox(width: width * 0.01),
                Text(
                  "+91-${auth.phoneNumber ?? "7994058834"}",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: width * 0.033,
                  ),
                ),
                SizedBox(width: width * 0.05),
                Icon(
                  Icons.cake_outlined,
                  color: Colors.white70,
                  size: width * 0.04,
                ),
                SizedBox(width: width * 0.01),
                Text(
                  "26 Oct 2004",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: width * 0.033,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Row(
      children: [
        ActionCard(
          icon: Icons.account_balance_wallet_outlined,
          title: "ZYTRA Wallet",
        ),
        SizedBox(width: width * 0.03),
        ActionCard(icon: Icons.support_agent, title: "Support"),
        SizedBox(width: width * 0.03),
        ActionCard(icon: Icons.payment, title: "Payments"),
      ],
    );
  }
}

class ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const ActionCard({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: height * 0.025),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(width * 0.04),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.black87, size: width * 0.07),
            SizedBox(height: height * 0.015),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: width * 0.03,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsCardsSection extends StatelessWidget {
  const SettingsCardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(width * 0.04),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          SettingsTile(
            icon: Icons.system_update_outlined,
            title: "App Update Available",
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.02,
                    vertical: height * 0.005,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(width * 0.02),
                  ),
                  child: Text(
                    "v1.0.0",
                    style: TextStyle(
                      fontSize: width * 0.03,
                      color: Colors.black54,
                    ),
                  ),
                ),
                SizedBox(width: width * 0.02),
                Icon(
                  Icons.chevron_right,
                  color: Colors.black45,
                  size: width * 0.05,
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade100, indent: width * 0.13),
          SettingsTile(
            icon: Icons.dark_mode_outlined,
            title: "Appearance",
            trailing: Container(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.025,
                vertical: height * 0.007,
              ),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(width * 0.02),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Dark",
                    style: TextStyle(
                      fontSize: width * 0.03,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(width: width * 0.01),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: width * 0.04,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade100, indent: width * 0.13),
          Padding(
            padding: EdgeInsets.all(width * 0.04),
            child: Row(
              children: [
                Icon(
                  Icons.visibility_off_outlined,
                  color: Colors.green,
                  size: width * 0.06,
                ),
                SizedBox(width: width * 0.04),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hide sensitive items",
                        style: TextStyle(
                          fontSize: width * 0.035,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: height * 0.005),
                      Text(
                        "Certain items will be hidden",
                        style: TextStyle(
                          fontSize: width * 0.03,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: provider.isSensitiveHidden,
                  onChanged: provider.toggleSensitiveItems,
                  activeColor: Colors.white,
                  activeTrackColor: Colors.black87,
                  inactiveTrackColor: Colors.grey.shade300,
                  inactiveThumbColor: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget trailing;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.all(width * 0.04),
      child: Row(
        children: [
          Icon(icon, color: Colors.black87, size: width * 0.06),
          SizedBox(width: width * 0.04),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: width * 0.035,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(left: width * 0.01),
      child: Text(
        title,
        style: TextStyle(
          fontSize: width * 0.03,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class InformationList extends StatelessWidget {
  const InformationList({super.key});

  @override
  Widget build(BuildContext context) {
    return const InfoListWidget(
      items: [
        ListItemData("Your orders", Icons.receipt_long_outlined),
        ListItemData("Your wishlist", Icons.favorite_border),
        ListItemData("Bookmarked Items", Icons.bookmark_border),
        ListItemData("Your prescriptions", Icons.medical_services_outlined),
        ListItemData("Address book", Icons.contact_page_outlined),
        ListItemData("GST details", Icons.description_outlined),
        ListItemData("E-gift cards", Icons.card_giftcard),
      ],
    );
  }
}

class PaymentsCouponsList extends StatelessWidget {
  const PaymentsCouponsList({super.key});

  @override
  Widget build(BuildContext context) {
    return const InfoListWidget(
      items: [
        ListItemData("Payment settings", Icons.payment_outlined),
        ListItemData("ZYTRA Wallet", Icons.account_balance_wallet_outlined),
        ListItemData("Claim Gift Card", Icons.card_giftcard),
        ListItemData("Your collected rewards", Icons.percent_outlined),
      ],
    );
  }
}

class OtherInformationList extends StatelessWidget {
  const OtherInformationList({super.key});

  @override
  Widget build(BuildContext context) {
    return const InfoListWidget(
      items: [
        ListItemData("Share the app", Icons.ios_share),
        ListItemData("About us", Icons.info_outline),
        ListItemData("Account privacy", Icons.lock_outline),
        ListItemData("Notification preferences", Icons.notifications_none),
        ListItemData("Log out", Icons.logout),
      ],
    );
  }
}

class InfoListWidget extends StatelessWidget {
  final List<ListItemData> items;

  const InfoListWidget({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(width * 0.04),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
        ],
      ),
      child: Column(
        children: items.map((item) {
          final isLast = items.last == item;
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(width * 0.04),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(width * 0.02),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        item.icon,
                        color: Colors.black87,
                        size: width * 0.05,
                      ),
                    ),
                    SizedBox(width: width * 0.04),
                    Expanded(
                      child: Text(
                        item.title,
                        style: TextStyle(
                          fontSize: width * 0.035,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.black26,
                      size: width * 0.05,
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Divider(
                  height: 1,
                  color: Colors.grey.shade100,
                  indent: width * 0.15,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class ProfileFooter extends StatelessWidget {
  const ProfileFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Center(
      child: Column(
        children: [
          Text(
            "ZYTRA",
            style: TextStyle(
              fontSize: width * 0.06,
              fontWeight: FontWeight.w900,
              color: Colors.black26,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: height * 0.005),
          Text(
            "v1.0.0",
            style: TextStyle(
              fontSize: width * 0.03,
              fontWeight: FontWeight.w600,
              color: Colors.black26,
            ),
          ),
        ],
      ),
    );
  }
}

class ListItemData {
  final String title;
  final IconData icon;

  const ListItemData(this.title, this.icon);
}
