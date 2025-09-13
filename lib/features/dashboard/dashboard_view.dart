import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influencer/core/theme/app_colors.dart';
import 'package:influencer/core/theme/text_styles.dart';
import 'package:influencer/core/utils/responsive.dart';
import 'package:influencer/core/services/notification_service.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_badge.dart';
import '../../core/widgets/app_loading.dart';
import 'dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final resp = context.responsive;
    
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.loadData();
          NotificationService.showSuccess('Refreshed', 'Dashboard data updated');
        },
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.all(resp.spacing(20)),
              sliver: Obx(() {
                final s = controller.summary.value;
                if (s == null) {
                  return SliverFillRemaining(
                    child: AppLoading(
                      message: 'Loading dashboard...',
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildListDelegate([
                    _buildWelcomeSection(resp),
                    SizedBox(height: resp.spacing(24)),
                    _buildStatsGrid(resp, s),
                    SizedBox(height: resp.spacing(24)),
                    _buildQuickActions(resp),
                    SizedBox(height: resp.spacing(24)),
                    _buildPerformanceChart(resp),
                    SizedBox(height: resp.spacing(24)),
                    _buildTopVideos(resp),
                    SizedBox(height: resp.spacing(24)),
                    _buildRecentActivity(resp),
                    SizedBox(height: resp.spacing(100)), // Bottom padding
                  ]),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(Responsive resp) {
    return SliverAppBar(
      expandedHeight: resp.isTablet ? 120 : 100,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.primary,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Dashboard',
          style: AppTextStyles.headlineSmall.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: () => NotificationService.showInfo('Notifications', 'No new notifications'),
        ),
        SizedBox(width: resp.spacing(8)),
      ],
    );
  }

  Widget _buildWelcomeSection(Responsive resp) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good morning! 👋',
          style: AppTextStyles.headlineLarge.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
        SizedBox(height: resp.spacing(8)),
        Text(
          'Ready to create amazing content today?',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.muted,
          ),
        ),
        SizedBox(height: resp.spacing(20)),
        _buildWelcomeCard(resp),
      ],
    );
  }

  Widget _buildWelcomeCard(Responsive resp) {
    return AppCard(
      backgroundColor: AppColors.surface,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(resp.spacing(8)),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.trending_up,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: resp.spacing(12)),
                    Text(
                      'Today\'s Performance',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.ink,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: resp.spacing(16)),
                Text(
                  'You\'re doing great! Keep up the momentum.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.muted,
                  ),
                ),
                SizedBox(height: resp.spacing(12)),
                Row(
                  children: [
                    AppStatusBadge(status: 'Active'),
                    SizedBox(width: resp.spacing(8)),
                    AppStatusBadge(status: 'Trending', type: AppBadgeType.success),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(resp.spacing(16)),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.rocket_launch,
              color: Colors.white,
              size: resp.isTablet ? 32 : 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(Responsive resp, dynamic s) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: AppTextStyles.headlineMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
        SizedBox(height: resp.spacing(16)),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: resp.isTablet ? 3 : 2,
          crossAxisSpacing: resp.spacing(16),
          mainAxisSpacing: resp.spacing(16),
          childAspectRatio: resp.isTablet ? 1.4 : 1.2,
          children: [
            AppStatCard(
              title: 'Total Videos',
              value: '${s.total}',
              icon: Icons.video_collection,
              iconColor: AppColors.primary,
            ),
            AppStatCard(
              title: 'Total Views',
              value: '${s.views}',
              icon: Icons.visibility,
              iconColor: AppColors.secondary,
            ),
            AppStatCard(
              title: 'Earnings',
              value: '₹${s.earnings.toStringAsFixed(0)}',
              icon: Icons.currency_rupee,
              iconColor: AppColors.success,
            ),
            AppStatCard(
              title: 'This Month',
              value: '₹${(s.earnings * 0.3).toStringAsFixed(0)}',
              icon: Icons.calendar_month,
              iconColor: AppColors.warning,
            ),
          ],
        ),
      ],
    );
  }



  Widget _buildPerformanceChart(Responsive resp) {
    final performanceValues = [100, 200, 150, 300, 250, 400, 380];
    final maxValue = performanceValues.reduce((a, b) => a > b ? a : b);
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Performance',
              style: AppTextStyles.headlineMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
            AppBadge(
              text: 'This Week',
              type: AppBadgeType.primary,
            ),
          ],
        ),
        SizedBox(height: resp.spacing(16)),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 200,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(7, (index) {
                    final value = performanceValues[index];
                    final barHeight = (value / maxValue) * 120;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '$value',
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                          ),
                        ),
                        SizedBox(height: resp.spacing(4)),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 500 + 100 * index),
                          width: resp.isTablet ? 28 : 22,
                          height: barHeight,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        SizedBox(height: resp.spacing(7)),
                        Text(
                          days[index],
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(Responsive resp) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTextStyles.headlineMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
        SizedBox(height: resp.spacing(16)),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                resp,
                'Upload Video',
                Icons.upload_outlined,
                AppColors.primary,
                () => NotificationService.showInfo('Upload', 'Upload feature coming soon'),
              ),
            ),
            SizedBox(width: resp.spacing(12)),
            Expanded(
              child: _buildActionButton(
                resp,
                'View Analytics',
                Icons.analytics_outlined,
                AppColors.secondary,
                () => NotificationService.showInfo('Analytics', 'Analytics feature coming soon'),
              ),
            ),
          ],
        ),
        SizedBox(height: resp.spacing(12)),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                resp,
                'Earnings',
                Icons.currency_rupee,
                AppColors.success,
                () => NotificationService.showInfo('Earnings', 'Earnings feature coming soon'),
              ),
            ),
            SizedBox(width: resp.spacing(12)),
            Expanded(
              child: _buildActionButton(
                resp,
                'Settings',
                Icons.settings_outlined,
                AppColors.muted,
                () => NotificationService.showInfo('Settings', 'Settings feature coming soon'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(Responsive resp, String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AppCard(
        backgroundColor: AppColors.surface,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(resp.spacing(12)),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: resp.isTablet ? 24 : 20,
              ),
            ),
            SizedBox(height: resp.spacing(12)),
            Text(
              title,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.ink,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopVideos(Responsive resp) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Top Videos',
              style: AppTextStyles.headlineMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
            TextButton(
              onPressed: () => NotificationService.showInfo('View All', 'View all videos feature coming soon'),
              child: Text(
                'View All',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: resp.spacing(16)),
        ...List.generate(3, (index) => _buildVideoItem(resp, index)),
      ],
    );
  }

  Widget _buildVideoItem(Responsive resp, int index) {
    return AppCard(
      margin: EdgeInsets.only(bottom: resp.spacing(12)),
      child: Row(
        children: [
          Container(
            width: resp.isTablet ? 60 : 50,
            height: resp.isTablet ? 60 : 50,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.play_circle_fill,
              color: Colors.white,
              size: 24,
            ),
          ),
          SizedBox(width: resp.spacing(16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Video #${index + 1}',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                SizedBox(height: resp.spacing(4)),
                Text(
                  '${(index + 1) * 5000} views',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${(index + 1) * 150}',
                style: AppTextStyles.amount.copyWith(
                  color: AppColors.success,
                ),
              ),
              SizedBox(height: resp.spacing(4)),
              AppStatusBadge(
                status: 'Trending',
                type: AppBadgeType.success,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(Responsive resp) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: AppTextStyles.headlineMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
        SizedBox(height: resp.spacing(16)),
        AppCard(
          child: Column(
            children: [
              _buildActivityItem(resp, 'Video uploaded', '2 hours ago', Icons.upload, AppColors.primary),
              _buildActivityDivider(resp),
              _buildActivityItem(resp, 'Payment received', '1 day ago', Icons.payment, AppColors.success),
              _buildActivityDivider(resp),
              _buildActivityItem(resp, 'New referral', '3 days ago', Icons.people, AppColors.secondary),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(Responsive resp, String title, String time, IconData icon, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: resp.spacing(8)),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(resp.spacing(8)),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(width: resp.spacing(16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                SizedBox(height: resp.spacing(2)),
                Text(
                  time,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityDivider(Responsive resp) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: resp.spacing(4)),
      child: Divider(
        color: AppColors.divider,
        height: 1,
      ),
    );
  }
}
