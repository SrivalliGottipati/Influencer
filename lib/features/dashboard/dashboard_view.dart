import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influencer/core/theme/app_colors.dart';
import 'package:influencer/core/theme/app_text_styles.dart';
import 'package:influencer/core/utils/responsive.dart';
import 'package:influencer/core/services/notification_service.dart';
import '../../core/widgets/info_card.dart';
import 'dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final resp = context.responsive;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.loadData();
          NotificationService.showSuccess('Refreshed', 'Dashboard data updated');
        },
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.all(resp.spacing(16)),
              sliver: Obx(() {
                final s = controller.summary.value;
                if (s == null) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: AppColors.primary),
                          SizedBox(height: resp.spacing(16)),
                          Text('Loading dashboard...', style: AppTextStyles.bodyMedium),
                        ],
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildListDelegate([
                    _buildWelcomeCard(resp),
                    SizedBox(height: resp.spacing(20)),
                    _buildStatsGrid(resp, s),
                    SizedBox(height: resp.spacing(24)),
                    _buildPerformanceChart(resp),
                    SizedBox(height: resp.spacing(24)),
                    _buildQuickActions(resp),
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

  Widget _buildWelcomeCard(Responsive resp) {
    return Container(
      padding: EdgeInsets.all(resp.spacing(20)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.accent, AppColors.accentLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back! 👋',
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: resp.spacing(8)),
                Text(
                  'Ready to create amazing content?',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(resp.spacing(12)),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.trending_up,
              color: Colors.white,
              size: resp.isTablet ? 32 : 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(Responsive resp, dynamic s) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: resp.isTablet ? 3 : 2,
      crossAxisSpacing: resp.spacing(16),
      mainAxisSpacing: resp.spacing(16),
      childAspectRatio: resp.isTablet ? 1.5 : 1.3,
      children: [
        _buildStatCard(
          resp,
          'Total Videos',
          '${s.total}',
          Icons.video_collection,
          AppColors.primary,
        ),
        _buildStatCard(
          resp,
          'Total Views',
          '${s.views}',
          Icons.visibility,
          AppColors.secondary,
        ),
        _buildStatCard(
          resp,
          'Earnings',
          '₹${s.earnings.toStringAsFixed(0)}',
          Icons.currency_rupee,
          AppColors.success,
        ),
        _buildStatCard(
          resp,
          'This Month',
          '₹${(s.earnings * 0.3).toStringAsFixed(0)}',
          Icons.calendar_month,
          AppColors.warning,
        ),
      ],
    );
  }


  Widget _buildStatCard(Responsive resp, String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(resp.spacing(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(resp.spacing(8)),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: resp.isTablet ? 24 : 18),
              ),
              Icon(Icons.more_vert, color: AppColors.neutral, size: 16),
            ],
          ),
          SizedBox(height: resp.spacing(5)),
          Text(
            value,
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.ink,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: resp.spacing(4)),
          Text(
            title,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.neutral,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceChart(Responsive resp) {
    final performanceValues = [100, 200, 150, 300, 250, 400, 380];
    final maxValue = performanceValues.reduce((a, b) => a > b ? a : b);
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Container(
      padding: EdgeInsets.all(resp.spacing(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Performance',
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.ink,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: resp.spacing(12),
                  vertical: resp.spacing(6),
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'This Week',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: resp.spacing(24)),
          SizedBox(
            height: 200,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (index) {
                final value = performanceValues[index];
                final barHeight = (value / maxValue) * 150;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '$value',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.ink,
                      ),
                    ),
                    SizedBox(height: resp.spacing(4)),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 500 + 100 * index),
                      width: resp.isTablet ? 28 : 24,
                      height: barHeight,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.secondary],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    SizedBox(height: resp.spacing(8)),
                    Text(
                      days[index],
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.neutral,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(Responsive resp) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
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
                Icons.upload,
                AppColors.primary,
                () => NotificationService.showInfo('Upload', 'Upload feature coming soon'),
              ),
            ),
            SizedBox(width: resp.spacing(12)),
            Expanded(
              child: _buildActionButton(
                resp,
                'View Analytics',
                Icons.analytics,
                AppColors.secondary,
                () => NotificationService.showInfo('Analytics', 'Analytics feature coming soon'),
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
      child: Container(
        padding: EdgeInsets.all(resp.spacing(16)),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: resp.isTablet ? 32 : 28),
            SizedBox(height: resp.spacing(8)),
            Text(
              title,
              style: AppTextStyles.bodyMedium.copyWith(
                color: color,
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
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.ink,
              ),
            ),
            TextButton(
              onPressed: () => NotificationService.showInfo('View All', 'View all videos feature coming soon'),
              child: Text('View All', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary)),
            ),
          ],
        ),
        SizedBox(height: resp.spacing(16)),
        ...List.generate(3, (index) => _buildVideoItem(resp, index)),
      ],
    );
  }

  Widget _buildVideoItem(Responsive resp, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: resp.spacing(12)),
      padding: EdgeInsets.all(resp.spacing(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: resp.isTablet ? 60 : 50,
            height: resp.isTablet ? 60 : 50,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.play_circle_fill, color: AppColors.primary),
          ),
          SizedBox(width: resp.spacing(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Video #${index + 1}',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                SizedBox(height: resp.spacing(4)),
                Text(
                  '${(index + 1) * 5000} views',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.neutral,
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
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.success,
                ),
              ),
              SizedBox(height: resp.spacing(4)),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: resp.spacing(8),
                  vertical: resp.spacing(2),
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Trending',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
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
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.ink,
          ),
        ),
        SizedBox(height: resp.spacing(16)),
        Container(
          padding: EdgeInsets.all(resp.spacing(16)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.neutral.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
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
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(width: resp.spacing(12)),
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
                Text(
                  time,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.neutral,
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
        color: AppColors.neutral.withValues(alpha: 0.2),
        height: 1,
      ),
    );
  }
}
