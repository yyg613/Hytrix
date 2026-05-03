import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/theme/colors.dart';
import '../../../domain/entities/anime.dart';
import '../../../domain/entities/watch_status.dart';
import '../../providers/anime_providers.dart';
import '../../providers/tracking_providers.dart';
import '../../widgets/episode_list.dart';

class DetailPage extends ConsumerStatefulWidget {
  final int animeId;

  const DetailPage({super.key, required this.animeId});

  @override
  ConsumerState<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends ConsumerState<DetailPage> {
  WatchStatus? _trackingStatus;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadTrackingStatus());
  }

  Future<void> _loadTrackingStatus() async {
    final status = await ref.read(trackingProvider.notifier).getStatus(widget.animeId);
    if (mounted) {
      setState(() => _trackingStatus = status);
    }
  }

  Future<void> _toggleTracking(Anime anime) async {
    if (_trackingStatus != null) {
      final action = await showDialog<WatchStatusType>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('追番设置'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: WatchStatusType.values.map((s) {
              return ListTile(
                title: Text(_statusName(s)),
                leading: Radio<WatchStatusType>(
                  value: s,
                  groupValue: _trackingStatus!.status,
                  onChanged: (v) {},
                ),
                onTap: () => Navigator.pop(ctx, s),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                ref.read(trackingProvider.notifier).removeTracking(widget.animeId);
                setState(() => _trackingStatus = null);
                Navigator.pop(ctx);
              },
              child: Text('取消追番', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
      if (action != null) {
        await ref.read(trackingProvider.notifier).toggleTracking(
          widget.animeId,
          action,
          totalEpisodes: anime.totalEpisodes,
        );
        await _loadTrackingStatus();
      }
    } else {
      await ref.read(trackingProvider.notifier).toggleTracking(
        widget.animeId,
        WatchStatusType.watching,
        totalEpisodes: anime.totalEpisodes,
      );
      await _loadTrackingStatus();
    }
  }

  String _statusName(WatchStatusType s) {
    switch (s) {
      case WatchStatusType.notWatched: return '未观看';
      case WatchStatusType.watching: return '在看';
      case WatchStatusType.completed: return '已看完';
      case WatchStatusType.dropped: return '已弃番';
    }
  }

  @override
  Widget build(BuildContext context) {
    final animeAsync = ref.watch(animeDetailProvider(widget.animeId));
    final episodesAsync = ref.watch(episodesProvider(widget.animeId));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: animeAsync.when(
        data: (anime) => CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 400,
              pinned: true,
              stretch: true,
              backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => Navigator.pop(context),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    anime.imageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: anime.imageUrl!,
                            fit: BoxFit.cover,
                            errorWidget: (context, error, stackTrace) => Container(
                              color: isDark ? AppColors.darkSurface : AppColors.lightSurfaceVariant,
                              child: const Icon(Icons.movie_rounded, size: 64, color: AppColors.textHint),
                            ),
                          )
                        : Container(
                            color: isDark ? AppColors.darkSurface : AppColors.lightSurfaceVariant,
                            child: const Icon(Icons.movie_rounded, size: 64, color: AppColors.textHint),
                          ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.transparent, Colors.black.withOpacity(0.5), Colors.black.withOpacity(0.9)],
                          stops: const [0, 0.4, 0.7, 1.0],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20, left: 20, right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(anime.title, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, shadows: [Shadow(offset: Offset(0, 2), blurRadius: 4, color: Colors.black54)])),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              if (anime.rating != null) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(gradient: AppColors.accentGradient, borderRadius: BorderRadius.circular(20)),
                                  child: Row(children: [const Icon(Icons.star_rounded, color: Colors.white, size: 18), const SizedBox(width: 4), Text(anime.rating!.toStringAsFixed(1), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))]),
                                ),
                                const SizedBox(width: 12),
                              ],
                              if (anime.totalEpisodes != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                                  child: Text('共 ${anime.totalEpisodes} 集', style: const TextStyle(color: Colors.white, fontSize: 14)),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: _trackingStatus != null
                          ? ElevatedButton.icon(
                              onPressed: () => _toggleTracking(anime),
                              icon: Icon(_trackingStatus!.status == WatchStatusType.watching ? Icons.favorite_rounded : Icons.check_rounded),
                              label: Text(_trackingStatus!.status == WatchStatusType.watching ? '在看' : _statusName(_trackingStatus!.status)),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                backgroundColor: _trackingStatus!.status == WatchStatusType.watching ? AppColors.accent : AppColors.primary,
                              ),
                            )
                          : ElevatedButton.icon(
                              onPressed: () => _toggleTracking(anime),
                              icon: const Icon(Icons.add_rounded),
                              label: const Text('追番'),
                              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                            ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.share_rounded),
                        label: const Text('分享'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: isDark ? AppColors.primaryLight : AppColors.primary),
                          foregroundColor: isDark ? AppColors.primaryLight : AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (anime.description != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Container(width: 4, height: 20, decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(2))),
                        const SizedBox(width: 10),
                        Text('简介', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      ]),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(anime.description!, style: TextStyle(color: isDark ? AppColors.textOnDarkSecondary : AppColors.textSecondary, fontSize: 14, height: 1.6)),
                      ),
                    ],
                  ),
                ),
              ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: Row(
                  children: [
                    Container(width: 4, height: 20, decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(2))),
                    const SizedBox(width: 10),
                    Text('分集列表', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Text('${episodesAsync.valueOrNull?.length ?? 0} 集',
                        style: TextStyle(color: isDark ? AppColors.textOnDarkSecondary : AppColors.textSecondary, fontSize: 14)),
                  ],
                ),
              ),
            ),

            episodesAsync.when(
              data: (episodes) => EpisodeList(episodes: episodes, animeId: widget.animeId, animeTitle: anime.title),
              loading: () => const SliverFillRemaining(child: Center(child: CircularProgressIndicator(color: AppColors.primary))),
              error: (error, stack) => SliverFillRemaining(child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error), const SizedBox(height: 16), Text('加载分集失败: $error')]))),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (error, stack) => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.error_outline_rounded, size: 64, color: AppColors.error),
          const SizedBox(height: 16),
          Text('加载失败', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(error.toString(), style: const TextStyle(color: AppColors.textSecondary), textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton.icon(onPressed: () { ref.invalidate(animeDetailProvider); ref.invalidate(episodesProvider); }, icon: const Icon(Icons.refresh_rounded), label: const Text('重试')),
        ])),
      ),
    );
  }
}
