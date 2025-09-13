import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influencer/core/theme/app_colors.dart';
import 'package:influencer/core/theme/app_text_styles.dart';
import 'package:influencer/core/utils/responsive.dart';
import 'package:influencer/core/services/notification_service.dart';
import '../../core/widgets/app_input.dart';
import '../../core/widgets/app_button.dart';
import 'upload_controller.dart';

class UploadView extends GetView<UploadController> {
  const UploadView({super.key});
  @override
  Widget build(BuildContext context) {
    final resp = context.responsive;
    final urlController = TextEditingController();
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(resp.spacing(20)),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildHeader(resp),
                SizedBox(height: resp.spacing(32)),
                _buildUploadCard(resp, urlController),
                SizedBox(height: resp.spacing(32)),
                _buildRecentUploads(resp),
                SizedBox(height: resp.spacing(32)),
                _buildTipsCard(resp),
                SizedBox(height: resp.spacing(100)), // Bottom padding
              ]),
            ),
          ),
        ],
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
          'Upload Video',
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
          icon: const Icon(Icons.help_outline, color: Colors.white),
          onPressed: () => NotificationService.showInfo('Help', 'Upload help coming soon'),
        ),
        SizedBox(width: resp.spacing(8)),
      ],
    );
  }

  Widget _buildHeader(Responsive resp) {
    return Container(
      padding: EdgeInsets.all(resp.spacing(24)),
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
                  'Share Your Content! 🎬',
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: resp.spacing(8)),
                Text(
                  'Upload your social media video links and start earning',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(resp.spacing(16)),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.video_collection,
              color: Colors.white,
              size: resp.isTablet ? 40 : 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadCard(Responsive resp, TextEditingController urlController) {
    return Container(
      padding: EdgeInsets.all(resp.spacing(24)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(resp.spacing(12)),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.link,
                  color: AppColors.primary,
                  size: resp.isTablet ? 28 : 24,
                ),
              ),
              SizedBox(width: resp.spacing(16)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Video URL',
                      style: AppTextStyles.titleLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.ink,
                      ),
                    ),
                    Text(
                      'Paste your social media video link',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.neutral,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: resp.spacing(24)),
          AppInput(
            controller: urlController,
            label: 'Paste video URL here',
            hintText: 'https://youtube.com/watch?v=...',
            keyboardType: TextInputType.url,
            prefixIcon: Icons.link,
          ),
          SizedBox(height: resp.spacing(20)),
          Obx(() => AppButton(
            label: 'Upload Video',
            loading: controller.loading.value,
            onPressed: () {
              if (urlController.text.trim().isEmpty) {
                NotificationService.showError('Error', 'Please enter a video URL');
                return;
              }
              controller.url.value = urlController.text.trim();
            controller.submit();
              urlController.clear();
            },
          )),
          SizedBox(height: resp.spacing(16)),
          _buildSupportedPlatforms(resp),
        ],
      ),
    );
  }

  Widget _buildSupportedPlatforms(Responsive resp) {
    final platforms = [
      {'name': 'YouTube', 'icon': Icons.play_circle_fill, 'color': AppColors.error},
      {'name': 'Instagram', 'icon': Icons.camera_alt, 'color': AppColors.warning},
      {'name': 'TikTok', 'icon': Icons.music_note, 'color': AppColors.primary},
      {'name': 'Facebook', 'icon': Icons.facebook, 'color': AppColors.info},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Supported Platforms',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.ink,
          ),
        ),
        SizedBox(height: resp.spacing(12)),
        Wrap(
          spacing: resp.spacing(12),
          runSpacing: resp.spacing(8),
          children: platforms.map((platform) {
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: resp.spacing(12),
                vertical: resp.spacing(8),
              ),
              decoration: BoxDecoration(
                color: (platform['color'] as Color).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: (platform['color'] as Color).withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    platform['icon'] as IconData,
                    color: platform['color'] as Color,
                    size: 16,
                  ),
                  SizedBox(width: resp.spacing(6)),
                  Text(
                    platform['name'] as String,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: platform['color'] as Color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRecentUploads(Responsive resp) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Uploads',
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.ink,
              ),
            ),
            TextButton(
              onPressed: () => NotificationService.showInfo('View All', 'View all uploads feature coming soon'),
              child: Text('View All', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary)),
            ),
          ],
        ),
        SizedBox(height: resp.spacing(16)),
        ...List.generate(3, (index) => _buildUploadItem(resp, index)),
      ],
    );
  }

  Widget _buildUploadItem(Responsive resp, int index) {
    final statuses = ['Processing', 'Live', 'Pending'];
    final statusColors = [AppColors.warning, AppColors.success, AppColors.neutral];
    final status = statuses[index % statuses.length];
    final statusColor = statusColors[index % statusColors.length];

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
            child: Icon(Icons.video_library, color: AppColors.primary),
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
                  'Uploaded 2 hours ago',
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
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: resp.spacing(8),
                  vertical: resp.spacing(4),
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: resp.spacing(4)),
              Text(
                '₹${(index + 1) * 50}',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTipsCard(Responsive resp) {
    return Container(
      padding: EdgeInsets.all(resp.spacing(20)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.secondary, AppColors.secondaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, color: Colors.white, size: 24),
              SizedBox(width: resp.spacing(12)),
              Text(
                'Upload Tips',
                style: AppTextStyles.titleMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: resp.spacing(16)),
          _buildTipItem(resp, 'Use high-quality video content for better engagement'),
          _buildTipItem(resp, 'Add relevant hashtags to increase visibility'),
          _buildTipItem(resp, 'Upload consistently to maintain audience interest'),
          _buildTipItem(resp, 'Engage with your audience through comments and likes'),
        ],
      ),
    );
  }

  Widget _buildTipItem(Responsive resp, String tip) {
    return Padding(
      padding: EdgeInsets.only(bottom: resp.spacing(8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: resp.spacing(6)),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: resp.spacing(12)),
          Expanded(
            child: Text(
              tip,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
