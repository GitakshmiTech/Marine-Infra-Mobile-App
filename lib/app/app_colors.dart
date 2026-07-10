import 'package:flutter/material.dart';

class AppColors {
  // Vibrant Brand Colors (from Multi-Color Design System Prompt)
  static const Color primaryBlue = Color(0xFF2563EB); // Vibrant Primary Blue
  static const Color cyan = Color(0xFF06B6D4);        // Cyan Accent
  static const Color emerald = Color(0xFF10B981);     // Emerald Accent
  static const Color purple = Color(0xFF8B5CF6);      // Purple Accent
  static const Color orange = Color(0xFFF97316);      // Orange Accent
  static const Color pink = Color(0xFFEC4899);        // Pink Accent
  static const Color yellow = Color(0xFFFBBF24);      // Yellow Accent

  // Backgrounds & Neutral Surfaces
  static const Color background = Color(0xFFF8FAFC);   // Premium Off White Background
  static const Color cardBg = Color(0xFFFFFFFF);       // Clean Card Background
  static const Color surface = Color(0xFFF1F5F9);      // Muted Surface Slate
  static const Color border = Color(0xFFE2E8F0);       // Structured Border Grey
  static const Color divider = Color(0xFFE2E8F0);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A);  // Deep Dark Slate
  static const Color textSecondary = Color(0xFF64748B);// Slate Gray
  static const Color textMuted = Color(0xFF94A3B8);    // Muted Grayish Blue

  // Fallback brand aliases
  static const Color primary = primaryBlue;
  static const Color secondary = Color(0xFF0A2540);
  static const Color accent = cyan;
  static const Color success = emerald;
  static const Color warning = yellow;
  static const Color error = pink;
  static const Color primaryLight = Color(0xFFE2E8F0);

  // Premium Gradients (from Design Prompt)
  static const List<Color> blueCyanGradient = [Color(0xFF2563EB), Color(0xFF06B6D4)];
  static const List<Color> purplePinkGradient = [Color(0xFF8B5CF6), Color(0xFFEC4899)];
  static const List<Color> emeraldCyanGradient = [Color(0xFF10B981), Color(0xFF06B6D4)];
  static const List<Color> orangeYellowGradient = [Color(0xFFF97316), Color(0xFFFBBF24)];
  static const List<Color> indigoPurpleGradient = [Color(0xFF4F46E5), Color(0xFF8B5CF6)];

  // Legacy fallback aliases
  static const List<Color> primaryGradient = blueCyanGradient;
  static const List<Color> secondaryGradient = indigoPurpleGradient;
  static const List<Color> accentGradient = emeraldCyanGradient;
}
