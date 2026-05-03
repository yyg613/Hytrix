import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/theme/colors.dart';
import '../../../domain/entities/watch_status.dart';
import '../../providers/tracking_providers.dart';

class TrackingPage extends ConsumerStatefulWidget {
  const TrackingPage({super.key});

  @override
  ConsumerState<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends ConsumerState<TrackingPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(trackingProvider.notifier).loadAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final trackingAsync = ref.watch(trackingProvider);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.favorite_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '我的追番',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.textOnDark : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            trackingAsync.when(
              data: (list) {
                if (list.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_border_rounded,
                            size: 64,
                            color: isDark
                                ? AppColors.textOnDarkSecondary
                                : AppColors.textHint,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '还没有追番',
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.textOnDarkSecondary
                                  : AppColors.textSecondary,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '在番剧详情页点击"追番"按钮即可添加',
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.textOnDarkSecondary
                                  : AppColors.textHint,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildListDelegate([
                    _buildSection(
                      context, '在看', WatchStatusType.watching, list, isDark),
                    _buildSection(
                      context, '已看完', WatchStatusType.completed, list, isDark),
                    _buildSection(
                      context, '已弃番', WatchStatusType.dropped, list, isDark),
                  ]),
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              ),
              error: (err, st) => SliverFillRemaining(
                child: Center(child: Text('加载失败: $err')),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    WatchStatusType status,
    List<WatchStatus> list,
    bool isDark,
  ) {
    final items = list.where((w) => w.status == status).toList();
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '$title (${items.length})',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textOnDark : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        ...items.map((w) => _buildAnimeItem(context, w, isDark)),
      ],
    );
  }

  Widget _buildAnimeItem(BuildContext context, WatchStatus status, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 56,
            height: 72,
            color: isDark ? AppColors.darkSurfaceLight : AppColors.lightSurfaceVariant,
            child: const Icon(Icons.movie_rounded, color: AppColors.textHint),
          ),
        ),
        title: Text(
          '番剧 #${status.animeId}',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textOnDark : AppColors.textPrimary,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: status.totalEpisodes != null && status.totalEpisodes! > 0
                  ? (status.currentEpisode ?? 0) / status.totalEpisodes!
                  : 0,
              backgroundColor: isDark ? AppColors.darkSurfaceLight : AppColors.lightSurfaceVariant,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
            const SizedBox(height: 4),
            Text(
              '已看 ${status.currentEpisode ?? 0} / ${status.totalEpisodes ?? "?"} 集',
              style: TextStyle(
                color: isDark
                    ? AppColors.textOnDarkSecondary
                    : AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
        onTap: () => context.push('/anime/${status.animeId}'),
      ),
    );
  }
}
