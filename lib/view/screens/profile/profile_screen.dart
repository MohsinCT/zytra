import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zytranow/controllers/home_provider.dart';
// auth_provider not required here; user info is handled by UserProvider
import 'package:zytranow/controllers/user_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light grey background
      body: CustomScrollView(
        slivers: [
          _buildDarkHeader(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildQuickActions(),
                  const SizedBox(height: 18),
                  _buildNameCard(context),
                  const SizedBox(height: 24),
                  _buildSettingsCards(context),
                  const SizedBox(height: 32),
                  _buildSectionTitle("YOUR INFORMATION"),
                  const SizedBox(height: 12),
                  _buildInfoList([
                    _ListItem("Your orders", Icons.receipt_long_outlined),
                    _ListItem("Your wishlist", Icons.favorite_border),
                    _ListItem("Bookmarked Items", Icons.bookmark_border),
                    _ListItem("Your prescriptions", Icons.medical_services_outlined),
                    _ListItem("Address book", Icons.contact_page_outlined),
                    _ListItem("GST details", Icons.description_outlined),
                    _ListItem("E-gift cards", Icons.card_giftcard),
                  ]),
                  const SizedBox(height: 32),
                  _buildSectionTitle("PAYMENTS & COUPONS"),
                  const SizedBox(height: 12),
                  _buildInfoList([
                    _ListItem("Payment settings", Icons.payment_outlined),
                    _ListItem("ZYTRA Wallet", Icons.account_balance_wallet_outlined),
                    _ListItem("Claim Gift Card", Icons.card_giftcard),
                    _ListItem("Your collected rewards", Icons.percent_outlined),
                  ]),
                  const SizedBox(height: 32),
                  _buildSectionTitle("OTHER INFORMATION"),
                  const SizedBox(height: 12),
                  _buildInfoList([
                    _ListItem("Share the app", Icons.ios_share),
                    _ListItem("About us", Icons.info_outline),
                    _ListItem("Account privacy", Icons.lock_outline),
                    _ListItem("Notification preferences", Icons.notifications_none),
                    _ListItem("Log out", Icons.logout),
                  ]),
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

  Widget _buildDarkHeader(BuildContext context) {
    
    return SliverToBoxAdapter(
      child: Container(
        color: const Color(0xFF1C1C1E), // Dark header background
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 10,
          left: 16,
          right: 16,
          bottom: 30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    child: const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
                    ),
                  ),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      "Profile",
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 34), // Balance the back button for exact centering
              ],
            ),
            const SizedBox(height: 10),
            Consumer<UserProvider>(
              builder: (context, user, _) {
                final displayName = user.fullName ?? 'Add your name';
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.phone_outlined, color: Colors.white70, size: 16),
                        const SizedBox(width: 4),
                        Text("+91-${user.phoneNumber}", style: const TextStyle(color: Colors.white70, fontSize: 13)),
                        const SizedBox(width: 20),
                        const Icon(Icons.cake_outlined, color: Colors.white70, size: 16),
                        const SizedBox(width: 4),
                        const Text("26 Oct 2004", style: TextStyle(color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        _buildActionCard(Icons.account_balance_wallet_outlined, "ZYTRA Wallet"),
        const SizedBox(width: 12),
        _buildActionCard(Icons.support_agent, "Support"),
        const SizedBox(width: 12),
        _buildActionCard(Icons.payment, "Payments"),
      ],
    );
  }

  Widget _buildActionCard(IconData icon, String title) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.black87, size: 28),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNameCard(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, _) {
      final hasName = (user.fullName ?? '').isNotEmpty;
      return GestureDetector(
        onTap: () => _showAddNameSheet(context, user.fullName),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8)],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.pink.shade50,
                child: Text(
                  hasName ? user.fullName!.substring(0, 1).toUpperCase() : 'A',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.pink),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasName ? user.fullName! : 'Add your name',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hasName ? 'Complete your account details' : 'Tap to add your full name',
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              Icon(Icons.edit, color: Colors.grey.shade400),
            ],
          ),
        ),
      );
    });
  }

  void _showAddNameSheet(BuildContext context, String? currentName) {
    final controller = TextEditingController(text: currentName ?? '');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Add your full name', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: 'Full name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final name = controller.text.trim();
                          if (name.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please enter a valid name')),
                            );
                            return;
                          }
                          final user = Provider.of<UserProvider>(context, listen: false);
                          user.setFullName(name);
                          Navigator.of(ctx).pop();
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Text('Save', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingsCards(BuildContext context) {
    final provider = context.watch<HomeProvider>();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Column(
        children: [
          _buildSettingsTile(
            icon: Icons.system_update_outlined,
            title: "App Update Available",
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text("v1.0.0", style: TextStyle(fontSize: 12, color: Colors.black54)),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, color: Colors.black45, size: 20),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade100, indent: 50),
          _buildSettingsTile(
            icon: Icons.dark_mode_outlined,
            title: "Appearance",
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text("Dark", style: TextStyle(fontSize: 12, color: Colors.black87)),
                  SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.black54),
                ],
              ),
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade100, indent: 50),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.visibility_off_outlined, color: Colors.green, size: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Hide sensitive items", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text("Certain items will be hidden", style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
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

  Widget _buildSettingsTile({required IconData icon, required String title, required Widget trailing}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, color: Colors.black87, size: 24),
          const SizedBox(width: 16),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
          trailing,
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54, letterSpacing: 0.5),
      ),
    );
  }

  Widget _buildInfoList(List<_ListItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Column(
        children: items.map((item) {
          final isLast = items.last == item;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(item.icon, color: Colors.black87, size: 20),
                    ),
                    const SizedBox(width: 16),
                    Expanded(child: Text(item.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
                    const Icon(Icons.chevron_right, color: Colors.black26, size: 20),
                  ],
                ),
              ),
              if (!isLast) Divider(height: 1, color: Colors.grey.shade100, indent: 60),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFooter() {
    return Center(
      child: Column(
        children: const [
          Text(
            "ZYTRA",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.black26,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 4),
          Text(
            "v1.0.0",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black26,
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
  _ListItem(this.title, this.icon);
}
