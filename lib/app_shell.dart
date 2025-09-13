import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influencer/core/theme/app_colors.dart';
import 'package:influencer/core/utils/responsive.dart';
import 'package:influencer/core/services/secure_store.dart';
import 'package:influencer/features/dashboard/dashboard_view.dart';
import 'package:influencer/features/upload/upload_view.dart';
import 'package:influencer/features/finance/finance_view.dart';
import 'package:influencer/features/notifications/notification_view.dart';
import 'package:influencer/features/kyc/kyc_view.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;
  final int _unreadNotifications = 3; // Mock unread count

  final List<Widget> _tabs = const [
    DashboardView(),
    UploadView(),
    FinanceView(),
    NotificationsView(),
    KycView(), // Profile tab
  ];

  final List<String> _tabTitles = [
    'InFly',
    'Upload',
    'Finance',
    'Notifications',
    'Profile / KYC',
  ];

  void _openProfile() => setState(() => _index = 4);

  @override
  Widget build(BuildContext context) {
    final resp = context.responsive;
    return Scaffold(
      appBar: AppBar(
        title: Text(_tabTitles[_index]), // Dynamic title
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none),
                onPressed: () => setState(() => _index = 3),
              ),
              if (_unreadNotifications > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: AppColors.danger,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$_unreadNotifications',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          height: resp.isTablet ? 70 : resp.isPhone ? 56 : 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _flexNavItem(icon: Icons.dashboard, label: 'Home', index: 0),
              _flexNavItem(icon: Icons.upload, label: 'Upload', index: 1),
              _flexNavItem(icon: Icons.trending_up, label: 'Finance', index: 2),
              _flexNavItem(icon: Icons.person, label: 'Profile', index: 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final resp = context.responsive;
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: resp.spacing(16), vertical: resp.spacing(12)),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.primary,
                    child: Icon(Icons.person, size: 32, color: Colors.white),
                  ),
                  SizedBox(width: resp.spacing(12)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Alex Johnson',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '+91 99999 99999',
                          style: TextStyle(color: Colors.black54, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: resp.spacing(8)),
            // Menu Section
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _drawerSection(title: 'Main', items: [
                      _drawerItem(icon: Icons.dashboard, label: 'Dashboard', onTap: () {
                        Navigator.pop(context);
                        setState(() => _index = 0);
                      }),
                      _drawerItem(icon: Icons.upload, label: 'Upload Video', onTap: () {
                        Navigator.pop(context);
                        setState(() => _index = 1);
                      }),
                      _drawerItem(icon: Icons.trending_up, label: 'Finance', onTap: () {
                        Navigator.pop(context);
                        setState(() => _index = 2);
                      }),
                    ]),
                    _drawerSection(title: 'Account', items: [
                      _drawerItem(icon: Icons.person, label: 'Profile / KYC', onTap: () {
                        Navigator.pop(context);
                        _openProfile();
                      }),
                      _drawerItem(icon: Icons.notifications, label: 'Notifications', onTap: () {
                        Navigator.pop(context);
                        setState(() => _index = 3);
                      }),
                    ]),
                  ],
                ),
              ),
            ),
            // Logout at bottom
            Padding(
              padding: EdgeInsets.all(resp.spacing(12)),
              child: Material(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                child: ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text('Log out', style: TextStyle(color: Colors.red)),
                  onTap: () async {
                    try {
                      final store = Get.find<SecureStore>();
                      await store.clearPhone();
                      await store.clearUserId();
                    } catch (_) {}
                    Get.offAllNamed('/login');
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerSection({required String title, required List<Widget> items}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Text(
              title.toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.grey,
                letterSpacing: 0.5,
              ),
            ),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _drawerItem({required IconData icon, required String label, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 24),
      title: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      ),
      onTap: onTap,
      horizontalTitleGap: 0,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  Widget _flexNavItem({required IconData icon, required String label, required int index}) {
    final resp = context.responsive;
    final active = index == _index;

    return Flexible(
      fit: FlexFit.tight,
      child: InkWell(
        onTap: () => setState(() => _index = index),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: resp.spacing(2)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                child: Icon(
                  icon,
                  color: active ? AppColors.primary : Colors.grey,
                  size: active ? (resp.isTablet ? 28 : 24) : (resp.isTablet ? 24 : 20),
                ),
              ),
              SizedBox(height: resp.spacing(1)),
              FittedBox(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: active ? AppColors.primary : Colors.grey,
                    fontSize: resp.isTablet ? 14 : 12,
                    fontWeight: active ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
