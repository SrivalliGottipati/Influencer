import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influencer/core/theme/app_colors.dart';
import 'package:influencer/core/theme/text_styles.dart';
import 'package:influencer/core/utils/responsive.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_badge.dart';
import '../../core/widgets/app_loading.dart';
import 'notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});
  @override
  Widget build(BuildContext context) {
    final resp = context.responsive;
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Obx(() {
        if (controller.isLoading.value) {
          return AppLoading(message: 'Loading notifications...');
        }

        return RefreshIndicator(
          onRefresh: controller.refreshNotifications,
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.all(resp.spacing(20)),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildHeader(context, resp),
                    SizedBox(height: resp.spacing(24)),
                    _buildNotificationsList(context, resp),
                    SizedBox(height: resp.spacing(100)), // Bottom padding
                  ]),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeader(BuildContext context, Responsive resp) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notifications',
          style: AppTextStyles.headlineLarge.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
        SizedBox(height: resp.spacing(8)),
        Text(
          'Stay updated with your latest activities',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.muted,
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationsList(BuildContext context, Responsive resp) {
    if (controller.items.isEmpty) {
      return AppCard(
        child: Column(
          children: [
            Icon(Icons.notifications_none, size: 48, color: AppColors.muted),
            SizedBox(height: resp.spacing(16)),
            Text(
              'No notifications yet',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.muted,
              ),
            ),
            SizedBox(height: resp.spacing(8)),
            Text(
              'You\'ll receive notifications about your activities here',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.mutedLight,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: controller.items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        return _buildNotificationItem(context, resp, index, item);
      }).toList(),
    );
  }

  Widget _buildNotificationItem(BuildContext context, Responsive resp, int index, String item) {
    return AppCard(
      margin: EdgeInsets.only(bottom: resp.spacing(12)),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(resp.spacing(8)),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.notifications,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          SizedBox(width: resp.spacing(16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notification #${index + 1}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                SizedBox(height: resp.spacing(4)),
                Text(
                  item,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
          AppBadge(
            text: '2h',
            type: AppBadgeType.neutral,
          ),
        ],
      ),
    );
  }
}
