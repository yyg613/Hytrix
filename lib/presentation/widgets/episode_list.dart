import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/colors.dart';
import '../../domain/entities/episode.dart';
import '../providers/video_providers.dart';

/// 分集列表组件 - 类似 Kazumi 风格
class EpisodeList extends ConsumerWidget {
  final List<Episode> episodes;
  final int animeId;
  final String animeTitle;
  final void Function(Episode episode)? onEpisodeTap;

  const EpisodeList({
    super.key,
    required this.episodes,
    required this.animeId,
    required this.animeTitle,
    this.onEpisodeTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final videoSources = ref.watch(videoSourcesProvider);

    if (episodes.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                Icon(
                  Icons.movie_filter_rounded,
                  size: 48,
                  color: isDark
                      ? AppColors.textOnDarkSecondary
                      : AppColors.textHint,
                ),
                const SizedBox(height: 16),
                Text(
                  '暂无分集信息',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textOnDarkSecondary
                        : AppColors.textSecondary,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // 使用网格布局，类似 Kazumi 风格
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 2.5,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final episode = episodes[index];
            return GestureDetector(
              onTap: () {
                if (onEpisodeTap != null) {
                  onEpisodeTap!(episode);
                } else if (videoSources.length > 1) {
                  _showVideoSourceDialog(
                    context,
                    ref,
                    episode,
                    videoSources,
                  );
                } else {
                  context.push(
                    '/player/$animeId/${episode.number}?title=${Uri.encodeComponent('$animeTitle - 第${episode.number}集')}',
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkSurfaceLight
                        : AppColors.lightSurfaceVariant,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    '第 ${episode.number} 集',
                    style: TextStyle(
                      color: isDark ? AppColors.textOnDark : AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            );
          },
          childCount: episodes.length,
        ),
      ),
    );
  }

  void _showVideoSourceDialog(
    BuildContext context,
    WidgetRef ref,
    Episode episode,
    List<dynamic> videoSources,
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
          '选择视频源',
          style: TextStyle(
            color: isDark ? AppColors.textOnDark : AppColors.textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: videoSources.map((source) {
            return ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.play_circle_outline,
                  color: AppColors.primary,
                ),
              ),
              title: Text(
                source.name,
                style: TextStyle(
                  color: isDark ? AppColors.textOnDark : AppColors.textPrimary,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                ref.read(selectedVideoSourceProvider.notifier).state = source;
                context.push(
                  '/player/$animeId/${episode.number}?title=${Uri.encodeComponent('$animeTitle - 第${episode.number}集')}',
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
