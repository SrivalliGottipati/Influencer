import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/text_styles.dart';

enum AppBadgeType { primary, secondary, success, warning, danger, info, neutral }

class AppBadge extends StatelessWidget {
  final String text;
  final AppBadgeType type;
  final IconData? icon;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  final bool rounded;

  const AppBadge({
    super.key,
    required this.text,
    this.type = AppBadgeType.primary,
    this.icon,
    this.fontSize,
    this.padding,
    this.rounded = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    final textColor = _getTextColor();

    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(rounded ? 20 : 8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: fontSize ?? 12,
              color: textColor,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: AppTextStyles.badge.copyWith(
              color: textColor,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }

  Color _getColor() {
    switch (type) {
      case AppBadgeType.primary:
        return AppColors.primaryLighter;
      case AppBadgeType.secondary:
        return AppColors.secondaryLighter;
      case AppBadgeType.success:
        return AppColors.successLighter;
      case AppBadgeType.warning:
        return AppColors.warningLighter;
      case AppBadgeType.danger:
        return AppColors.dangerLighter;
      case AppBadgeType.info:
        return AppColors.infoLighter;
      case AppBadgeType.neutral:
        return AppColors.mutedLighter;
    }
  }

  Color _getTextColor() {
    switch (type) {
      case AppBadgeType.primary:
        return AppColors.primary;
      case AppBadgeType.secondary:
        return AppColors.secondary;
      case AppBadgeType.success:
        return AppColors.success;
      case AppBadgeType.warning:
        return AppColors.warning;
      case AppBadgeType.danger:
        return AppColors.danger;
      case AppBadgeType.info:
        return AppColors.info;
      case AppBadgeType.neutral:
        return AppColors.muted;
    }
  }
}

class AppStatusBadge extends StatelessWidget {
  final String status;
  final AppBadgeType? type;

  const AppStatusBadge({
    super.key,
    required this.status,
    this.type,
  });

  @override
  Widget build(BuildContext context) {
    final badgeType = type ?? _getStatusType(status);
    return AppBadge(
      text: status,
      type: badgeType,
    );
  }

  AppBadgeType _getStatusType(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'completed':
      case 'success':
      case 'live':
        return AppBadgeType.success;
      case 'pending':
      case 'processing':
      case 'waiting':
        return AppBadgeType.warning;
      case 'failed':
      case 'error':
      case 'cancelled':
        return AppBadgeType.danger;
      case 'draft':
      case 'inactive':
        return AppBadgeType.neutral;
      default:
        return AppBadgeType.primary;
    }
  }
}
