import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyle {
  static const String fontFamily = 'Urbanist';

  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 40,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.20,
    letterSpacing: -0.8,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.20,
    letterSpacing: -0.6,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700, // Bold
    color: AppColors.textPrimary,
    height: 1.20,
    letterSpacing: -0.4,
  );

  static const TextStyle h4 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700, // Bold
    color: AppColors.textPrimary,
    height: 1.20,
    letterSpacing: -0.2,
  );

  // Body Styles
  static const TextStyle body20Semibold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.20,
  );

  static const TextStyle body18Medium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.20,
  );

  static const TextStyle body17Semibold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.20,
  );

  static const TextStyle body16Medium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.40,
  );

  static const TextStyle body16Regular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.40,
  );

  static const TextStyle body15Regular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.40,
  );

  static const TextStyle body14Medium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600, // Medium/Semibold
    color: AppColors.textPrimary,
    height: 1.20,
  );

  static const TextStyle body14Regular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.20,
  );

  static const TextStyle body12Regular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.40,
  );

  static const TextStyle body08Medium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 8,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    height: 1.20,
  );

  // Fallbacks for previous names
  static const TextStyle displayLarge = h1;
  static const TextStyle displayMedium = h2;
  static const TextStyle titleLarge = h3;
  static const TextStyle titleMedium = h4;
  static const TextStyle bodyLarge = body16Regular;
  static const TextStyle bodyMedium = body14Regular;
  static const TextStyle bodySmall = body12Regular;
  static const TextStyle labelLarge = body14Medium;
  static const TextStyle labelSmall = body08Medium;
}
