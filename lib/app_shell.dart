import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influencer/core/theme/app_colors.dart';
import 'package:influencer/core/theme/text_styles.dart';
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

class _AppShellState extends State<AppShell> with TickerProviderStateMixin {
  int _index = 0;
  final int _unreadNotifications = 3; // Mock unread count
  late AnimationController _animationController;

  final List<Widget> _tabs = const [
    DashboardView(),
    UploadView(),
    FinanceView(),
    NotificationsView(),
    KycView(), // Profile tab
  ];

  final List<String> _tabTitles = [
    'Dashboard',
    'Upload',
    'Finance',
    'Notifications',
    'Profile',
  ];

  final List<IconData> _tabIcons = [
    Icons.dashboard_outlined,
    Icons.upload_outlined,
    Icons.trending_up_outlined,
    Icons.notifications_outlined,
    Icons.person_outline,
  ];

  final List<IconData> _tabIconsFilled = [
    Icons.dashboard,
    Icons.upload,
    Icons.trending_up,
    Icons.notifications,
    Icons.person,
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _openProfile() => setState(() => _index = 4);

  @override
  Widget build(BuildContext context) {
    final resp = context.responsive;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: _buildAppBar(resp),
      drawer: _buildDrawer(context),
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: _buildBottomNavBar(resp),
    );
  }

  PreferredSizeWidget _buildAppBar(Responsive resp) {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      shadowColor: AppColors.shadowSubtle,
      surfaceTintColor: Colors.transparent,
      title: Row(
        children: [
          Text(
            _tabTitles[_index],
            style: AppTextStyles.headlineMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
      actions: [
        // Notifications
        Stack(
          children: [
            IconButton(
              icon: Icon(
                _index == 3 ? _tabIconsFilled[3] : _tabIcons[3],
                color: _index == 3 ? AppColors.primary : AppColors.muted,
              ),
              onPressed: () => setState(() => _index = 3),
            ),
            if (_unreadNotifications > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.danger,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Text(
                    '$_unreadNotifications',
                    style: AppTextStyles.badge.copyWith(
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(width: resp.spacing(8)),
      ],
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final resp = context.responsive;
    return Drawer(
      backgroundColor: AppColors.surface,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Header
            Container(
              padding: EdgeInsets.all(resp.spacing(20)),
              decoration: BoxDecoration(
                //gradient: AppColors.primaryGradient,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: const Icon(
                      Icons.person,
                      size: 32,
                      // color: Colors.white,
                    ),
                  ),
                  SizedBox(width: resp.spacing(16)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Alex Johnson',
                          style: AppTextStyles.headlineSmall.copyWith(
                          //  color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: resp.spacing(4)),
                        Text(
                          '+91 99999 99999',
                          style: AppTextStyles.bodyMedium.copyWith(
                            //color: Colors.white.withOpacity(0.8),
                          ),
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
                padding: EdgeInsets.symmetric(vertical: resp.spacing(8)),
                child: Column(
                  children: [
                    _drawerSection(title: 'Main', items: [
                      _drawerItem(
                        icon: Icons.dashboard_outlined,
                        label: 'Dashboard',
                        isActive: _index == 0,
                        onTap: () {
                          Navigator.pop(context);
                          setState(() => _index = 0);
                        },
                      ),
                      _drawerItem(
                        icon: Icons.upload_outlined,
                        label: 'Upload Video',
                        isActive: _index == 1,
                        onTap: () {
                          Navigator.pop(context);
                          setState(() => _index = 1);
                        },
                      ),
                      _drawerItem(
                        icon: Icons.trending_up_outlined,
                        label: 'Finance',
                        isActive: _index == 2,
                        onTap: () {
                          Navigator.pop(context);
                          setState(() => _index = 2);
                        },
                      ),
                    ]),
                    _drawerSection(title: 'Account', items: [
                      _drawerItem(
                        icon: Icons.person_outline,
                        label: 'Profile',
                        isActive: _index == 4,
                        onTap: () {
                          Navigator.pop(context);
                          _openProfile();
                        },
                      ),
                      _drawerItem(
                        icon: Icons.notifications_outlined,
                        label: 'Notifications',
                        isActive: _index == 3,
                        onTap: () {
                          Navigator.pop(context);
                          setState(() => _index = 3);
                        },
                      ),
                    ]),
                  ],
                ),
              ),
            ),
            
            // Logout at bottom
            Padding(
              padding: EdgeInsets.all(resp.spacing(16)),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.dangerLighter,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: const Icon(Icons.logout, color: AppColors.danger),
                  title: Text(
                    'Log out',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.danger,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(
              title.toUpperCase(),
              style: AppTextStyles.overline.copyWith(
                color: AppColors.muted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryLighter.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? AppColors.primary : AppColors.muted,
          size: 24,
        ),
        title: Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isActive ? AppColors.primary : AppColors.ink,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        onTap: onTap,
        horizontalTitleGap: 0,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildBottomNavBar(Responsive resp) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.borderLight, width: 1),
        ),
      ),
      child: SafeArea(
        child: Container(
          height: resp.isTablet ? 100 : 80,
          padding: EdgeInsets.symmetric(vertical: resp.spacing(8)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(icon: _tabIcons[0], filledIcon: _tabIconsFilled[0], label: 'Home', index: 0),
              _buildNavItem(icon: _tabIcons[1], filledIcon: _tabIconsFilled[1], label: 'Upload', index: 1),
              _buildNavItem(icon: _tabIcons[2], filledIcon: _tabIconsFilled[2], label: 'Finance', index: 2),
              _buildNavItem(icon: _tabIcons[4], filledIcon: _tabIconsFilled[4], label: 'Profile', index: 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData filledIcon,
    required String label,
    required int index,
  }) {
    final resp = context.responsive;
    final active = index == _index;

    return GestureDetector(
      onTap: () {
        _animationController.forward().then((_) {
          _animationController.reset();
        });
        setState(() => _index = index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: resp.spacing(12),
          vertical: resp.spacing(8),
        ),
        decoration: BoxDecoration(
          color: active ? AppColors.primaryLighter.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                active ? filledIcon : icon,
                key: ValueKey(active),
                color: active ? AppColors.primary : AppColors.muted,
                size: resp.isTablet ? 24 : 20,
              ),
            ),
            SizedBox(height: resp.spacing(4)),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: active ? AppColors.primary : AppColors.muted,
                fontWeight: active ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
