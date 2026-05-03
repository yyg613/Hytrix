import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 主题模式枚举
enum AppThemeMode {
  system,
  light,
  dark,
}

/// 主题状态管理
class ThemeNotifier extends StateNotifier<AppThemeMode> {
  ThemeNotifier() : super(AppThemeMode.system);

  void setThemeMode(AppThemeMode mode) {
    state = mode;
  }

  ThemeMode get themeMode {
    switch (state) {
      case AppThemeMode.system:
        return ThemeMode.system;
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
    }
  }
}

/// 主题 Provider
final themeProvider = StateNotifierProvider<ThemeNotifier, AppThemeMode>((ref) {
  return ThemeNotifier();
});

/// 播放设置
class PlayerSettings {
  final double defaultSpeed;
  final bool autoPlay;
  final bool showDanmaku;

  const PlayerSettings({
    this.defaultSpeed = 1.0,
    this.autoPlay = true,
    this.showDanmaku = false,
  });

  PlayerSettings copyWith({
    double? defaultSpeed,
    bool? autoPlay,
    bool? showDanmaku,
  }) {
    return PlayerSettings(
      defaultSpeed: defaultSpeed ?? this.defaultSpeed,
      autoPlay: autoPlay ?? this.autoPlay,
      showDanmaku: showDanmaku ?? this.showDanmaku,
    );
  }
}

/// 播放设置状态管理
class PlayerSettingsNotifier extends StateNotifier<PlayerSettings> {
  PlayerSettingsNotifier() : super(const PlayerSettings());

  void setDefaultSpeed(double speed) {
    state = state.copyWith(defaultSpeed: speed);
  }

  void setAutoPlay(bool value) {
    state = state.copyWith(autoPlay: value);
  }

  void setShowDanmaku(bool value) {
    state = state.copyWith(showDanmaku: value);
  }
}

/// 播放设置 Provider
final playerSettingsProvider =
    StateNotifierProvider<PlayerSettingsNotifier, PlayerSettings>((ref) {
  return PlayerSettingsNotifier();
});
