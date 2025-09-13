import 'package:flutter/material.dart';

class AppColors {
  // Primary Brand Colors
  static const Color primary = Color(0xFF6366F1);     // Modern indigo
  static const Color primaryLight = Color(0xFF818CF8); // Lighter indigo
  static const Color primaryDark = Color(0xFF4F46E5);  // Darker indigo
  
  // Secondary Colors
  static const Color secondary = Color(0xFF10B981);    // Modern emerald
  static const Color secondaryLight = Color(0xFF34D399); // Lighter emerald
  static const Color secondaryDark = Color(0xFF059669);  // Darker emerald
  
  // Accent Colors
  static const Color accent = Color(0xFFF59E0B);       // Amber
  static const Color accentLight = Color(0xFFFCD34D);  // Lighter amber
  static const Color accentDark = Color(0xFFD97706);   // Darker amber
  
  // Neutral Colors
  static const Color ink = Color(0xFF111827);          // Dark gray
  static const Color inkLight = Color(0xFF374151);     // Medium gray
  static const Color neutral = Color(0xFF6B7280);      // Light gray
  static const Color muted = Color(0xFF6B7280);        // Light gray
  static const Color mutedLight = Color(0xFF9CA3AF);   // Very light gray
  
  // Background Colors
  static const Color background = Color(0xFFF9FAFB);   // Very light gray
  static const Color bg = Color(0xFFF9FAFB);           // Very light gray
  static const Color bgSecondary = Color(0xFFF3F4F6);  // Light gray
  static const Color surface = Colors.white;           // White
  static const Color surfaceSecondary = Color(0xFFF8FAFC); // Off white
  
  // Status Colors
  static const Color success = Color(0xFF10B981);      // Green
  static const Color successLight = Color(0xFFD1FAE5); // Light green
  static const Color warning = Color(0xFFF59E0B);      // Amber
  static const Color warningLight = Color(0xFFFEF3C7); // Light amber
  static const Color error = Color(0xFFEF4444);        // Red
  static const Color danger = Color(0xFFEF4444);       // Red
  static const Color dangerLight = Color(0xFFFEE2E2);  // Light red
  static const Color info = Color(0xFF3B82F6);         // Blue
  static const Color infoLight = Color(0xFFDBEAFE);    // Light blue
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient successGradient = LinearGradient(
    colors: [success, Color(0xFF34D399)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Shadow Colors
  static const Color shadowLight = Color(0x0A000000);
  static const Color shadowMedium = Color(0x14000000);
  static const Color shadowDark = Color(0x1F000000);
}
