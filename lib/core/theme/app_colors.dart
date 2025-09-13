import 'package:flutter/material.dart';

class AppColors {
  // Primary Brand Colors - Sophisticated Purple/Indigo
  static const Color primary = Color(0xFF5B21B6);      // Deep purple
  static const Color primaryLight = Color(0xFF7C3AED); // Medium purple
  static const Color primaryDark = Color(0xFF4C1D95);  // Dark purple
  static const Color primaryLighter = Color(0xFFA78BFA); // Light purple
  
  // Secondary Colors - Elegant Teal
  static const Color secondary = Color(0xFF0D9488);    // Deep teal
  static const Color secondaryLight = Color(0xFF14B8A6); // Medium teal
  static const Color secondaryDark = Color(0xFF0F766E);  // Dark teal
  static const Color secondaryLighter = Color(0xFF5EEAD4); // Light teal
  
  // Accent Colors - Warm Orange
  static const Color accent = Color(0xFFEA580C);       // Deep orange
  static const Color accentLight = Color(0xFFF97316);  // Medium orange
  static const Color accentDark = Color(0xFFC2410C);   // Dark orange
  static const Color accentLighter = Color(0xFFFDBA74); // Light orange
  
  // Neutral Colors - Sophisticated Grays
  static const Color ink = Color(0xFF0F172A);          // Almost black
  static const Color inkLight = Color(0xFF334155);     // Dark gray
  static const Color inkLighter = Color(0xFF64748B);   // Medium gray
  static const Color neutral = Color(0xFF94A3B8);      // Light gray
  static const Color muted = Color(0xFF94A3B8);        // Light gray
  static const Color mutedLight = Color(0xFFCBD5E1);   // Very light gray
  static const Color mutedLighter = Color(0xFFE2E8F0); // Lightest gray
  
  // Background Colors - Clean and Minimal
  static const Color background = Color(0xFFFAFAFA);   // Off white
  static const Color bg = Color(0xFFFAFAFA);           // Off white
  static const Color bgSecondary = Color(0xFFF1F5F9);  // Light gray
  static const Color surface = Colors.white;           // Pure white
  static const Color surfaceSecondary = Color(0xFFF8FAFC); // Subtle white
  static const Color surfaceTertiary = Color(0xFFF1F5F9); // Light surface
  
  // Status Colors - Refined and Professional
  static const Color success = Color(0xFF059669);      // Deep green
  static const Color successLight = Color(0xFF10B981); // Medium green
  static const Color successLighter = Color(0xFFD1FAE5); // Light green
  static const Color warning = Color(0xFFD97706);      // Deep amber
  static const Color warningLight = Color(0xFFF59E0B); // Medium amber
  static const Color warningLighter = Color(0xFFFEF3C7); // Light amber
  static const Color error = Color(0xFFDC2626);        // Deep red
  static const Color danger = Color(0xFFDC2626);       // Deep red
  static const Color dangerLight = Color(0xFFEF4444);  // Medium red
  static const Color dangerLighter = Color(0xFFFEE2E2); // Light red
  static const Color info = Color(0xFF0284C7);         // Deep blue
  static const Color infoLight = Color(0xFF0EA5E9);    // Medium blue
  static const Color infoLighter = Color(0xFFDBEAFE);  // Light blue
  
  // Special Colors
  static const Color border = Color(0xFFE2E8F0);       // Light border
  static const Color borderLight = Color(0xFFF1F5F9);  // Lighter border
  static const Color divider = Color(0xFFE2E8F0);      // Divider color
  
  // Gradient Colors - Subtle and Elegant
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
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient successGradient = LinearGradient(
    colors: [success, successLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient subtleGradient = LinearGradient(
    colors: [surface, surfaceSecondary],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  // Shadow Colors - Soft and Natural
  static const Color shadowLight = Color(0x08000000);
  static const Color shadowMedium = Color(0x12000000);
  static const Color shadowDark = Color(0x1A000000);
  static const Color shadowSubtle = Color(0x04000000);
  
  // Glass Effect Colors
  static const Color glassBackground = Color(0x40FFFFFF);
  static const Color glassBorder = Color(0x20FFFFFF);
  
  // Overlay Colors
  static const Color overlay = Color(0x80000000);
  static const Color overlayLight = Color(0x40000000);
}
