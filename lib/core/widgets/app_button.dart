import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/text_styles.dart';

enum AppButtonType { primary, secondary, outline, text, danger }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final AppButtonType type;
  final IconData? icon;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final bool fullWidth;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.loading = false,
    this.type = AppButtonType.primary,
    this.icon,
    this.width,
    this.height,
    this.padding,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final buttonWidget = _buildButton(context);
    
    if (fullWidth) {
      return SizedBox(
        width: width ?? double.infinity,
        height: height ?? 48,
        child: buttonWidget,
      );
    }
    
    return SizedBox(
      width: width,
      height: height ?? 48,
      child: buttonWidget,
    );
  }

  Widget _buildButton(BuildContext context) {
    switch (type) {
      case AppButtonType.primary:
        return ElevatedButton(
          onPressed: loading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
          child: _buildButtonContent(),
        );
      
      case AppButtonType.secondary:
        return ElevatedButton(
          onPressed: loading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            foregroundColor: Colors.white,
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
          child: _buildButtonContent(),
        );
      
      case AppButtonType.outline:
        return OutlinedButton(
          onPressed: loading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.border, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
          child: _buildButtonContent(),
        );
      
      case AppButtonType.text:
        return TextButton(
          onPressed: loading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: _buildButtonContent(),
        );
      
      case AppButtonType.danger:
        return ElevatedButton(
          onPressed: loading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.danger,
            foregroundColor: Colors.white,
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
          child: _buildButtonContent(),
        );
    }
  }

  Widget _buildButtonContent() {
    if (loading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            type == AppButtonType.outline || type == AppButtonType.text 
                ? AppColors.primary 
                : Colors.white,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(label, style: AppTextStyles.button),
        ],
      );
    }

    return Text(label, style: AppTextStyles.button);
  }
}
