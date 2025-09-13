// import 'package:flutter/material.dart';
// import '../theme/app_colors.dart';
// import '../theme/text_styles.dart';
//
// class AppInput extends StatelessWidget {
//   final TextEditingController controller;
//   final String label;
//   final String? hintText;
//   final IconData? prefixIcon;
//   final IconData? suffixIcon;
//   final TextInputType? keyboardType;
//   final bool obscure;
//   final int? maxLines;
//   final int? maxLength;
//   final String? Function(String?)? validator;
//   final bool readOnly;
//   final bool enabled;
//   final AutovalidateMode autovalidateMode;
//   final VoidCallback? onTap;
//   final VoidCallback? onSuffixTap;
//   final String? helperText;
//   final String? errorText;
//   final bool filled;
//   final Color? fillColor;
//   final EdgeInsetsGeometry? contentPadding;
//
//   const AppInput({
//     super.key,
//     required this.controller,
//     required this.label,
//     this.hintText,
//     this.prefixIcon,
//     this.suffixIcon,
//     this.keyboardType,
//     this.obscure = false,
//     this.maxLines,
//     this.maxLength,
//     this.validator,
//     this.readOnly = false,
//     this.enabled = true,
//     this.autovalidateMode = AutovalidateMode.onUserInteraction,
//     this.onTap,
//     this.onSuffixTap,
//     this.helperText,
//     this.errorText,
//     this.filled = true,
//     this.fillColor,
//     this.contentPadding,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         TextFormField(
//           controller: controller,
//           obscureText: obscure,
//           maxLines: maxLines ?? 1,
//           maxLength: maxLength,
//           keyboardType: keyboardType,
//           readOnly: readOnly,
//           enabled: enabled,
//           autovalidateMode: autovalidateMode,
//           validator: validator,
//           onTap: onTap,
//           style: AppTextStyles.bodyMedium,
//           decoration: InputDecoration(
//             labelText: label,
//             hintText: hintText,
//             helperText: helperText,
//             errorText: errorText,
//             prefixIcon: prefixIcon != null
//                 ? Icon(prefixIcon, color: AppColors.muted, size: 20)
//                 : null,
//             suffixIcon: suffixIcon != null
//                 ? GestureDetector(
//                     onTap: onSuffixTap,
//                     child: Icon(suffixIcon, color: AppColors.muted, size: 20),
//                   )
//                 : null,
//             filled: filled,
//             fillColor: fillColor ?? AppColors.surface,
//             contentPadding: contentPadding ?? const EdgeInsets.symmetric(
//               horizontal: 20,
//               vertical: 16
//             ),
//             labelStyle: AppTextStyles.labelMedium.copyWith(
//               color: AppColors.muted,
//             ),
//             hintStyle: AppTextStyles.bodyMedium.copyWith(
//               color: AppColors.mutedLight,
//             ),
//             helperStyle: AppTextStyles.caption.copyWith(
//               color: AppColors.muted,
//             ),
//             errorStyle: AppTextStyles.caption.copyWith(
//               color: AppColors.danger,
//             ),
//             counterStyle: AppTextStyles.caption.copyWith(
//               color: AppColors.muted,
//             ),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(16),
//               borderSide: const BorderSide(color: AppColors.border),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(16),
//               borderSide: const BorderSide(color: AppColors.border),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(16),
//               borderSide: const BorderSide(color: AppColors.primary, width: 2),
//             ),
//             errorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(16),
//               borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
//             ),
//             focusedErrorBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(16),
//               borderSide: const BorderSide(color: AppColors.danger, width: 2),
//             ),
//             disabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(16),
//               borderSide: const BorderSide(color: AppColors.borderLight),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/text_styles.dart';

class AppInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final TextInputType? keyboardType;
  final bool obscure;
  final int? maxLines;
  final int? maxLength;
  final String? Function(String?)? validator;
  final bool readOnly;
  final bool enabled;
  final AutovalidateMode autovalidateMode;
  final VoidCallback? onTap;
  final VoidCallback? onSuffixTap;
  final String? helperText;
  final String? errorText;
  final bool filled;
  final Color? fillColor;
  final EdgeInsetsGeometry? contentPadding;

  // 🔑 New fields
  final TextAlign? textAlign;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;

  const AppInput({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.obscure = false,
    this.maxLines,
    this.maxLength,
    this.validator,
    this.readOnly = false,
    this.enabled = true,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.onTap,
    this.onSuffixTap,
    this.helperText,
    this.errorText,
    this.filled = true,
    this.fillColor,
    this.contentPadding,

    // 🔑 new optional props
    this.textAlign,
    this.inputFormatters,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          obscureText: obscure,
          maxLines: maxLines ?? 1,
          maxLength: maxLength,
          keyboardType: keyboardType,
          readOnly: readOnly,
          enabled: enabled,
          autovalidateMode: autovalidateMode,
          validator: validator,
          onTap: onTap,
          onChanged: onChanged, // ✅ pass through
          textAlign: textAlign ?? TextAlign.start, // ✅ pass through
          inputFormatters: inputFormatters, // ✅ pass through
          style: AppTextStyles.bodyMedium,
          decoration: InputDecoration(
            labelText: label,
            hintText: hintText,
            helperText: helperText,
            errorText: errorText,
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: AppColors.muted, size: 20)
                : null,
            suffixIcon: suffixIcon != null
                ? GestureDetector(
              onTap: onSuffixTap,
              child: Icon(suffixIcon, color: AppColors.muted, size: 20),
            )
                : null,
            filled: filled,
            fillColor: fillColor ?? AppColors.surface,
            contentPadding: contentPadding ?? const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            labelStyle: AppTextStyles.labelMedium.copyWith(
              color: AppColors.muted,
            ),
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.mutedLight,
            ),
            helperStyle: AppTextStyles.caption.copyWith(
              color: AppColors.muted,
            ),
            errorStyle: AppTextStyles.caption.copyWith(
              color: AppColors.danger,
            ),
            counterStyle: AppTextStyles.caption.copyWith(
              color: AppColors.muted,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.danger, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.borderLight),
            ),
          ),
        ),
      ],
    );
  }
}
