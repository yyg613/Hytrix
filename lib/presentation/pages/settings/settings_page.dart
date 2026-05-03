import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors.dart';
import '../../providers/settings_providers.dart';

/// 设置页 - 类似 Kazumi 风格
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final playerSettings = ref.watch(playerSettingsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 标题
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(
                '设置',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textOnDark : AppColors.textPrimary,
                ),
              ),
            ),

            // 外观设置
            _buildSectionHeader(context, '外观', Icons.palette_rounded),
            _buildSettingCard(
              context,
              isDark: isDark,
              children: [
                _buildSettingItem(
                  context,
                  icon: Icons.brightness_6_rounded,
                  title: '主题模式',
                  subtitle: _getThemeModeName(themeMode),
                  onTap: () => _showThemeDialog(context, ref, themeMode),
                  isDark: isDark,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 播放设置
            _buildSectionHeader(context, '播放', Icons.play_circle_rounded),
            _buildSettingCard(
              context,
              isDark: isDark,
              children: [
                _buildSettingItem(
                  context,
                  icon: Icons.speed_rounded,
                  title: '默认倍速',
                  subtitle: '${playerSettings.defaultSpeed}x',
                  onTap: () => _showSpeedDialog(
                    context,
                    ref,
                    playerSettings.defaultSpeed,
                  ),
                  isDark: isDark,
                ),
                Divider(
                  height: 1,
                  color: isDark
                      ? AppColors.darkSurfaceLight
                      : AppColors.lightSurfaceVariant,
                ),
                _buildSwitchItem(
                  context,
                  icon: Icons.play_arrow_rounded,
                  title: '自动播放',
                  subtitle: '进入播放页自动开始播放',
                  value: playerSettings.autoPlay,
                  onChanged: (value) {
                    ref.read(playerSettingsProvider.notifier).setAutoPlay(value);
                  },
                  isDark: isDark,
                ),
                Divider(
                  height: 1,
                  color: isDark
                      ? AppColors.darkSurfaceLight
                      : AppColors.lightSurfaceVariant,
                ),
                _buildSwitchItem(
                  context,
                  icon: Icons.subtitles_rounded,
                  title: '显示弹幕',
                  subtitle: '默认开启弹幕',
                  value: playerSettings.showDanmaku,
                  onChanged: (value) {
                    ref.read(playerSettingsProvider.notifier).setShowDanmaku(value);
                  },
                  isDark: isDark,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 视频源设置
            _buildSectionHeader(context, '视频源', Icons.video_library_rounded),
            _buildSettingCard(
              context,
              isDark: isDark,
              children: [
                _buildSettingItem(
                  context,
                  icon: Icons.source_rounded,
                  title: '视频源管理',
                  subtitle: '添加或管理视频源',
                  onTap: () => context.push('/video-sources'),
                  isDark: isDark,
                ),
                Divider(
                  height: 1,
                  color: isDark
                      ? AppColors.darkSurfaceLight
                      : AppColors.lightSurfaceVariant,
                ),
                _buildSettingItem(
                  context,
                  icon: Icons.rule_rounded,
                  title: '规则管理',
                  subtitle: '管理 Kazumi 规则',
                  onTap: () => context.push('/rule-manager'),
                  isDark: isDark,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 关于
            _buildSectionHeader(context, '关于', Icons.info_outline_rounded),
            _buildSettingCard(
              context,
              isDark: isDark,
              children: [
                _buildSettingItem(
                  context,
                  icon: Icons.update_rounded,
                  title: '版本',
                  subtitle: '1.0.0',
                  onTap: () {},
                  isDark: isDark,
                ),
                Divider(
                  height: 1,
                  color: isDark
                      ? AppColors.darkSurfaceLight
                      : AppColors.lightSurfaceVariant,
                ),
                _buildSettingItem(
                  context,
                  icon: Icons.code_rounded,
                  title: '开源许可',
                  subtitle: '查看开源项目许可',
                  onTap: () {
                    // TODO: 显示开源许可
                  },
                  isDark: isDark,
                ),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColors.primary,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingCard(
    BuildContext context, {
    required bool isDark,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: AppColors.primary,
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.textOnDark : AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: isDark
              ? AppColors.textOnDarkSecondary
              : AppColors.textSecondary,
          fontSize: 13,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: isDark
            ? AppColors.textOnDarkSecondary
            : AppColors.textHint,
      ),
      onTap: onTap,
    );
  }

  Widget _buildSwitchItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool isDark,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: AppColors.primary,
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.textOnDark : AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: isDark
              ? AppColors.textOnDarkSecondary
              : AppColors.textSecondary,
          fontSize: 13,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }

  String _getThemeModeName(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.system:
        return '跟随系统';
      case AppThemeMode.light:
        return '浅色';
      case AppThemeMode.dark:
        return '深色';
    }
  }

  void _showThemeDialog(
    BuildContext context,
    WidgetRef ref,
    AppThemeMode currentMode,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          '主题模式',
          style: TextStyle(
            color: isDark ? AppColors.textOnDark : AppColors.textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppThemeMode.values.map((mode) {
            final isSelected = mode == currentMode;
            return ListTile(
              title: Text(
                _getThemeModeName(mode),
                style: TextStyle(
                  color: isDark ? AppColors.textOnDark : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              leading: Radio<AppThemeMode>(
                value: mode,
                groupValue: currentMode,
                onChanged: (value) {
                  if (value != null) {
                    ref.read(themeProvider.notifier).setThemeMode(value);
                    Navigator.pop(context);
                  }
                },
                activeColor: AppColors.primary,
              ),
              onTap: () {
                ref.read(themeProvider.notifier).setThemeMode(mode);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showSpeedDialog(
    BuildContext context,
    WidgetRef ref,
    double currentSpeed,
  ) {
    final speeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0, 3.0];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          '默认倍速',
          style: TextStyle(
            color: isDark ? AppColors.textOnDark : AppColors.textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: speeds.map((speed) {
            final isSelected = speed == currentSpeed;
            return ListTile(
              title: Text(
                '${speed}x',
                style: TextStyle(
                  color: isDark ? AppColors.textOnDark : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              leading: Radio<double>(
                value: speed,
                groupValue: currentSpeed,
                onChanged: (value) {
                  if (value != null) {
                    ref.read(playerSettingsProvider.notifier).setDefaultSpeed(value);
                    Navigator.pop(context);
                  }
                },
                activeColor: AppColors.primary,
              ),
              onTap: () {
                ref.read(playerSettingsProvider.notifier).setDefaultSpeed(speed);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
