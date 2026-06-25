import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zytranow/controllers/home_provider.dart';
import 'package:zytranow/controllers/theme_provider.dart';
import 'package:zytranow/controllers/user_provider.dart';
import 'package:zytranow/view/screens/location/select_location_screen.dart';
import 'package:zytranow/view/screens/auth/login_screen.dart';
import 'package:zytranow/core/constants/app_constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBackground, // Zytra white background
      body: CustomScrollView(
        slivers: [
          _buildDarkHeader(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  _buildQuickActions(context),
                  const SizedBox(height: 24),
                  _buildSettingsCards(context),
                  const SizedBox(height: 28),
                  _buildSectionTitle("YOUR INFORMATION", context),
                  const SizedBox(height: 12),
                  _buildInfoList([
                    _ListItem(
                      "Your Orders",
                      Icons.receipt_long_outlined,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Orders screen coming soon!'),
                          ),
                        );
                      },
                    ),
                    _ListItem(
                      "Wishlist",
                      Icons.favorite_border,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Wishlist screen coming soon!'),
                          ),
                        );
                      },
                    ),
                    _ListItem(
                      "Saved Addresses",
                      Icons.location_on_outlined,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SelectLocationScreen(),
                          ),
                        );
                      },
                    ),
                  ], context),
                  const SizedBox(height: 32),
                  _buildLogoutTile(context),
                  const SizedBox(height: 48),
                  _buildFooter(),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Dark Header
  // ---------------------------------------------------------------------------
  Widget _buildDarkHeader(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        color: const Color(0xFF1C1C1E), // Dark premium background
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 16,
          left: 16,
          right: 16,
          bottom: 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row: Back button + Title
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      "Your Account",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 36), // Balance the back button
              ],
            ),
            const SizedBox(height: 24),
            // Mobile Number display
            Consumer<UserProvider>(
              builder: (context, user, _) {
                final displayPhone = user.phoneNumber.isNotEmpty
                    ? user.phoneNumber
                    : '9876543210';
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.phone_iphone,
                          color: Colors.white54,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "+91 $displayPhone",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Name Card
                    _buildNameCard(context, user),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Name Card
  // ---------------------------------------------------------------------------
  Widget _buildNameCard(BuildContext context, UserProvider user) {
    final hasName = user.fullName != null && user.fullName!.trim().isNotEmpty;
    final displayName = user.fullName?.trim() ?? '';

    return GestureDetector(
      onTap: () => _showAddNameSheet(context, user),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: hasName
              ? Colors.white.withOpacity(0.08)
              : kPrimaryPink.withOpacity(0.15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: hasName
                ? Colors.white.withOpacity(0.12)
                : kPrimaryPink.withOpacity(0.4),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Circular avatar with initials or a default user icon
            CircleAvatar(
              radius: 24,
              backgroundColor: hasName
                  ? Colors.white.withOpacity(0.12)
                  : kPrimaryPink.withOpacity(0.25),
              child: hasName
                  ? Text(
                      displayName.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(
                      Icons.person_add_alt_1_outlined,
                      color: kPrimaryPink,
                      size: 20,
                    ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasName ? "Welcome, $displayName" : "Add your name",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: hasName ? Colors.white : kPrimaryPink,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Complete your account details",
                    style: TextStyle(fontSize: 12, color: Colors.white60),
                  ),
                ],
              ),
            ),
            Icon(
              hasName ? Icons.edit_outlined : Icons.chevron_right,
              color: hasName ? Colors.white38 : kPrimaryPink,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Name Bottom Sheet
  // ---------------------------------------------------------------------------
  void _showAddNameSheet(BuildContext context, UserProvider user) {
    final controller = TextEditingController(text: user.fullName ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: context.cardBackground,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag Handle
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: context.isDark
                          ? Colors.grey.shade700
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'What is your name?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: context.textDark,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'This will be displayed on your profile.',
                  style: TextStyle(fontSize: 13, color: context.textMuted),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: controller,
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  style: TextStyle(color: context.textDark),
                  decoration: InputDecoration(
                    hintText: 'Full name',
                    hintStyle: TextStyle(color: context.textMuted),
                    filled: true,
                    fillColor: context.inputFill,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: context.borderTheme),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: kPrimaryPink,
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: context.borderTheme),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      final name = controller.text.trim();
                      if (name.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter a valid name'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return;
                      }
                      user.setFullName(name);
                      Navigator.of(ctx).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryPink,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Quick Actions (Wallet, Support, Payments)
  // ---------------------------------------------------------------------------
  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        _buildActionCard(
          Icons.account_balance_wallet_outlined,
          "ZYTRA Wallet",
          context,
        ),
        const SizedBox(width: 12),
        _buildActionCard(Icons.support_agent, "Support", context),
        const SizedBox(width: 12),
        _buildActionCard(Icons.payment, "Payments", context),
      ],
    );
  }

  Widget _buildActionCard(IconData icon, String title, BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: context.cardBackground,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(context.isDark ? 0.005 : 0.015),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: context.textDark, size: 26),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: context.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Settings Cards (Appearance + Sensitive Items toggle)
  // ---------------------------------------------------------------------------
  Widget _buildSettingsCards(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();
    return Container(
      decoration: BoxDecoration(
        color: context.cardBackground,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(context.isDark ? 0.005 : 0.015),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Appearance Settings
          Consumer<ThemeProvider>(
            builder: (ctx, theme, _) {
              return _buildSettingsTile(
                icon: Icons.dark_mode_outlined,
                title: "Appearance",
                context: context,
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: context.inputFill,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: context.borderTheme),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: theme.mode,
                      dropdownColor: context.cardBackground,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        size: 16,
                        color: context.textDark,
                      ),
                      style: TextStyle(
                        fontSize: 12,
                        color: context.textDark,
                        fontWeight: FontWeight.w600,
                      ),
                      items: const [
                        DropdownMenuItem(value: 'light', child: Text('Light')),
                        DropdownMenuItem(value: 'dark', child: Text('Dark')),
                      ],
                      onChanged: (v) {
                        if (v != null) theme.setMode(v);
                      },
                    ),
                  ),
                ),
              );
            },
          ),
          Divider(height: 1, color: context.dividerColor, indent: 50),
          // Sensitive Items toggle
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.visibility_off_outlined,
                  color: context.textDark,
                  size: 22,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hide sensitive items",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: context.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Certain items will be hidden",
                        style: TextStyle(
                          fontSize: 11,
                          color: context.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: homeProvider.isSensitiveHidden,
                  onChanged: homeProvider.toggleSensitiveItems,
                  activeColor: Colors.white,
                  activeTrackColor: kPrimaryPink,
                  inactiveTrackColor: context.isDark
                      ? Colors.grey.shade800
                      : Colors.grey.shade300,
                  inactiveThumbColor: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required Widget trailing,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, color: context.textDark, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: context.textDark,
              ),
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Information List
  // ---------------------------------------------------------------------------
  Widget _buildSectionTitle(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: context.textMuted,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildInfoList(List<_ListItem> items, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardBackground,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(context.isDark ? 0.005 : 0.015),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: items.map((item) {
          final isLast = items.last == item;
          return Column(
            children: [
              InkWell(
                onTap: item.onTap,
                borderRadius: BorderRadius.circular(14),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: context.inputFill,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          item.icon,
                          color: context.textDark,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: context.textDark,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: context.textMuted,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              if (!isLast)
                Divider(height: 1, color: context.dividerColor, indent: 56),
            ],
          );
        }).toList(),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Log out button
  // ---------------------------------------------------------------------------
  Widget _buildLogoutTile(BuildContext context) {
    return InkWell(
      onTap: () => _confirmLogout(context),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.cardBackground,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(context.isDark ? 0.005 : 0.015),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50.withOpacity(
                  context.isDark ? 0.15 : 1.0,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.logout,
                color: context.isDark
                    ? Colors.red.shade400
                    : Colors.red.shade600,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                "Log out",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: context.isDark
                      ? Colors.red.shade400
                      : Colors.red.shade600,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: context.isDark
                  ? Colors.red.shade400.withOpacity(0.4)
                  : Colors.red.shade200,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Log out?",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: context.textDark,
          ),
        ),
        content: Text(
          "You will need to sign in again to place orders.",
          style: TextStyle(color: context.textDark),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Cancel", style: TextStyle(color: context.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              final user = Provider.of<UserProvider>(context, listen: false);
              user.setPhoneNumber('');
              user.clearName();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text("Log out"),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Footer
  // ---------------------------------------------------------------------------
  Widget _buildFooter() {
    return const Center(
      child: Column(
        children: [
          Text(
            "ZYTRA",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Colors.black12,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 4),
          Text(
            "v1.0.0",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.black12,
            ),
          ),
        ],
      ),
    );
  }
}

class _ListItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  _ListItem(this.title, this.icon, {required this.onTap});
}
