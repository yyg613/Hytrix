import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'presentation/pages/main_page.dart';
import 'presentation/pages/detail/detail_page.dart';
import 'presentation/pages/player/player_page.dart';
import 'presentation/pages/video_source/video_source_page.dart';
import 'presentation/pages/rule_manager/rule_manager_page.dart';
import 'presentation/providers/settings_providers.dart';

/// 路由配置
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const MainPage(),
      ),
      GoRoute(
        path: '/anime/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return DetailPage(animeId: id);
        },
      ),
      GoRoute(
        path: '/player/:animeId/:episodeNumber',
        builder: (context, state) {
          final animeId = int.parse(state.pathParameters['animeId']!);
          final episodeNumber = int.parse(state.pathParameters['episodeNumber']!);
          final title = state.uri.queryParameters['title'] ?? '播放';
          final videoUrl = state.uri.queryParameters['url'];
          return PlayerPage(
            animeId: animeId,
            episodeNumber: episodeNumber,
            title: title,
            videoUrl: videoUrl,
          );
        },
      ),
      GoRoute(
        path: '/video-sources',
        builder: (context, state) => const VideoSourcePage(),
      ),
      GoRoute(
        path: '/rule-manager',
        builder: (context, state) => const RuleManagerPage(),
      ),
    ],
  );
});

/// 应用入口
class AnimeSTApp extends ConsumerWidget {
  const AnimeSTApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'AnimeST',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode == AppThemeMode.system
          ? ThemeMode.system
          : themeMode == AppThemeMode.light
              ? ThemeMode.light
              : ThemeMode.dark,
      routerConfig: router,
    );
  }
}
