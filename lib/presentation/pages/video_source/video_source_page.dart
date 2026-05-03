import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/colors.dart';
import '../../../data/datasources/remote/video_source.dart';
import '../../../data/datasources/remote/demo_video_source.dart';
import '../../providers/video_providers.dart';

/// 视频源管理页面
class VideoSourcePage extends ConsumerStatefulWidget {
  const VideoSourcePage({super.key});

  @override
  ConsumerState<VideoSourcePage> createState() => _VideoSourcePageState();
}

class _VideoSourcePageState extends ConsumerState<VideoSourcePage> {
  final _urlController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _showAddSourceDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          '添加视频源',
          style: TextStyle(
            color: isDark ? AppColors.textOnDark : AppColors.textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '名称',
                hintText: '例如：我的视频源',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: '视频 URL',
                hintText: 'https://example.com/video.mp4',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_urlController.text.isNotEmpty) {
                // 添加自定义视频源
                ref.read(videoSourcesProvider.notifier).state = [
                  ...ref.read(videoSourcesProvider),
                  CustomVideoSource(
                    videoUrl: _urlController.text,
                    sourceName: _nameController.text.isNotEmpty
                        ? _nameController.text
                        : '自定义源',
                  ),
                ];
                _urlController.clear();
                _nameController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text('添加'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final videoSources = ref.watch(videoSourcesProvider);
    final selectedSource = ref.watch(selectedVideoSourceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('视频源管理'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: _showAddSourceDialog,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 说明卡片
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8),
                    Text(
                      '视频源说明',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '视频源用于获取番剧的播放地址。您可以：\n'
                  '• 添加自定义视频 URL 进行测试\n'
                  '• 导入规则文件（参考 Kazumi 规则格式）\n'
                  '• 使用示例源进行功能测试',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 视频源列表
          Text(
            '已添加的视频源',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),

          if (videoSources.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.video_library_outlined,
                    size: 48,
                    color: isDark
                        ? AppColors.textOnDarkSecondary
                        : AppColors.textHint,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '暂无视频源',
                    style: TextStyle(
                      color: isDark
                          ? AppColors.textOnDarkSecondary
                          : AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '点击右上角 + 添加视频源',
                    style: TextStyle(
                      color: isDark
                          ? AppColors.textOnDarkSecondary
                          : AppColors.textHint,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
          else
            ...videoSources.map((source) {
              final isSelected = selectedSource == source;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected
                      ? Border.all(
                          color: AppColors.primary,
                          width: 2,
                        )
                      : null,
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withOpacity(0.2)
                          : (isDark
                              ? AppColors.darkSurfaceLight
                              : AppColors.lightSurfaceVariant),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.play_circle_outline,
                      color: isSelected
                          ? AppColors.primary
                          : (isDark
                              ? AppColors.textOnDarkSecondary
                              : AppColors.textSecondary),
                    ),
                  ),
                  title: Text(
                    source.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textOnDark : AppColors.textPrimary,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(
                          Icons.check_circle,
                          color: AppColors.primary,
                        )
                      : null,
                  onTap: () {
                    ref.read(selectedVideoSourceProvider.notifier).state = source;
                  },
                ),
              );
            }),
        ],
      ),
    );
  }
}
