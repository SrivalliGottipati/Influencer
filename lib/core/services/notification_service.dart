import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';

class NotificationService {
  static void showSuccess(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.success.withOpacity(0.9),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }

  static void showError(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.danger.withOpacity(0.9),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.error, color: Colors.white),
    );
  }

  static void showInfo(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.accent.withOpacity(0.9),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.info, color: Colors.white),
    );
  }

  static void showWarning(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.warning.withOpacity(0.9),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.warning, color: Colors.white),
    );
  }

  // Custom notification for specific actions
  static void showLoginSuccess(String phone) {
    showSuccess('Welcome!', 'Login successful for $phone');
  }

  static void showOtpSent(String phone) {
    showInfo('OTP Sent', 'Verification code sent to $phone');
  }

  static void showRegistrationSuccess(String name) {
    showSuccess('Welcome $name!', 'Registration completed successfully');
  }

  static void showProfileUpdated() {
    showSuccess('Profile Updated', 'Your profile has been saved successfully');
  }

  static void showVideoUploaded() {
    showSuccess('Video Uploaded', 'Your video link has been added successfully');
  }

  static void showReferralShared() {
    showInfo('Referral Shared', 'Your invite link has been shared successfully');
  }
}
