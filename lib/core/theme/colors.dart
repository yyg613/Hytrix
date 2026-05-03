import 'package:flutter/material.dart';

/// 应用颜色常量 - 现代动漫风格
class AppColors {
  AppColors._();

  // 主色调 - 深紫蓝渐变
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryDark = Color(0xFF5A52D5);
  static const Color primaryLight = Color(0xFF8B83FF);

  // 强调色 - 珊瑚粉
  static const Color accent = Color(0xFFFF6B6B);
  static const Color accentLight = Color(0xFFFF8E8E);

  // 背景色
  static const Color lightBackground = Color(0xFFF8F9FE);
  static const Color darkBackground = Color(0xFF0F0F1A);
  static const Color darkSurface = Color(0xFF1A1A2E);
  static const Color darkSurfaceLight = Color(0xFF252540);

  // 表面色
  static const Color lightSurface = Colors.white;
  static const Color lightSurfaceVariant = Color(0xFFF3F4F8);

  // 状态色
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFB74D);
  static const Color error = Color(0xFFEF5350);
  static const Color info = Color(0xFF42A5F5);

  // 文字色
  static const Color textPrimary = Color(0xFF1E1E2D);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9CA3AF);
  static const Color textOnDark = Colors.white;
  static const Color textOnDarkSecondary = Color(0xFFB0B0C0);

  // 渐变色
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFF8B83FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, Color(0xFFFF8E8E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [darkBackground, Color(0xFF16213E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // 卡片渐变
  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1E1E30), Color(0xFF252545)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
