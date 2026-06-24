import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors
  static const Color primaryColor = Color(0xFF6366F1);
  static const Color primaryLight = Color(0xFEEEF2FF);
  static const Color primaryDark = Color(0xFF4F46E5);

  // Secondary Colors
  static const Color secondaryColor = Color(0xFF10B981);
  static const Color secondaryLight = Color(0xFFF0FDF4);
  static const Color secondaryDark = Color(0xFF059669);

  // Status Colors
  static const Color successColor = Color(0xFF10B981);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color warningColor = Color(0xFFFB923C);
  static const Color infoColor = Color(0xFF3B82F6);

  // Neutral Colors
  static const Color neutralWhite = Color(0xFFFFFFFF);
  static const Color neutral50 = Color(0xFFF9FAFB);
  static const Color neutral100 = Color(0xFFF3F4F6);
  static const Color neutral200 = Color(0xFFE5E7EB);
  static const Color neutral300 = Color(0xFFD1D5DB);
  static const Color neutral400 = Color(0xFF9CA3AF);
  static const Color neutral500 = Color(0xFF6B7280);
  static const Color neutral600 = Color(0xFF4B5563);
  static const Color neutral700 = Color(0xFF374151);
  static const Color neutral800 = Color(0xFF1F2937);
  static const Color neutral900 = Color(0xFF111827);

  // Shadow
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> elevatedShadow = [
    BoxShadow(
      color: Color(0x2A000000),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];

  // Radius
  static const double radiusXS = 4;
  static const double radiusSM = 8;
  static const double radiusMD = 12;
  static const double radiusLG = 16;
  static const double radiusXL = 20;
  static const double radiusXXL = 24;

  // Spacing
  static const double spacingXS = 4;
  static const double spacingSM = 8;
  static const double spacingMD = 12;
  static const double spacingLG = 16;
  static const double spacingXL = 24;
  static const double spacingXXL = 32;
}
