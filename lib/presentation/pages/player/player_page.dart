import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '../../../core/theme/colors.dart';
import '../../providers/video_providers.dart';

/// 播放器页面 - 使用 media_kit
class PlayerPage extends ConsumerStatefulWidget {
  final int animeId;
  final int episodeNumber;
  final String title;
  final String? videoUrl;

  const PlayerPage({
    super.key,
    required this.animeId,
    required this.episodeNumber,
    required this.title,
    this.videoUrl,
  });

  @override
  ConsumerState<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends ConsumerState<PlayerPage> {
  late final Player _player;
  late final VideoController _controller;
  bool _showControls = true;
  bool _isInitialized = false;
  bool _isPlaying = false;
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // 初始化 media_kit
    MediaKit.ensureInitialized();
    _player = Player();
    _controller = VideoController(_player);

    // 锁定横屏
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    // 全屏显示
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // 延迟执行，避免在 initState 中修改 Provider 状态
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.videoUrl != null) {
        _playVideo(widget.videoUrl!);
      } else {
        _resolveAndPlay();
      }
    });
  }

  Future<void> _resolveAndPlay() async {
    final source = ref.read(selectedVideoSourceProvider);
    if (source == null) {
      setState(() {
        _errorMessage = '未配置视频源\n请点击下方按钮手动输入视频地址';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 去掉 " - 第N集" 后缀，只保留番剧名用于搜索
      final animeName = widget.title.replaceAll(RegExp(r' - 第\d+集$'), '');
      await ref.read(videoResolveProvider.notifier).resolve(
        source,
        animeName,
        widget.episodeNumber,
      );

      final videoState = ref.read(videoResolveProvider);
      if (videoState.videoInfo != null) {
        await _playVideo(
          videoState.videoInfo!.url,
          headers: videoState.videoInfo!.headers,
        );
      } else {
        setState(() {
          _errorMessage = '${videoState.error ?? "视频源解析失败"}\n\n请点击下方按钮手动输入视频地址';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = '解析出错: $e\n请点击下方按钮手动输入视频地址';
        _isLoading = false;
      });
    }
  }

  Future<void> _playVideo(
    String url, {
    Map<String, String>? headers,
    int retryCount = 0,
  }) async {
    const maxRetries = 3;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 创建 Media 对象
      final media = Media(url, httpHeaders: headers ?? {});

      // 打开媒体
      await _player.open(media);

      // 监听播放状态
      _player.stream.playing.listen((playing) {
        if (mounted) {
          setState(() {
            _isPlaying = playing;
          });
        }
      });

      // 监听错误
      _player.stream.error.listen((error) {
        if (mounted && error.isNotEmpty) {
          setState(() {
            _errorMessage = '播放失败: $error';
          });
        }
      });

      setState(() {
        _isInitialized = true;
        _isLoading = false;
      });

      // 开始播放
      _player.play();
    } catch (e) {
      if (retryCount < maxRetries) {
        // 自动重试
        setState(() {
          _errorMessage = '播放失败，正在重试 (${retryCount + 1}/$maxRetries)...';
        });
        await Future.delayed(Duration(seconds: (retryCount + 1) * 2));
        if (mounted) {
          _playVideo(url, headers: headers, retryCount: retryCount + 1);
        }
      } else {
        setState(() {
          _errorMessage = '视频播放失败（已重试${maxRetries}次）\n\n'
              '可能的原因：\n'
              '1. 视频链接已失效\n'
              '2. 网络连接问题\n'
              '3. 视频格式不支持\n\n'
              '请点击下方按钮手动输入视频地址';
          _isLoading = false;
        });
      }
    }
  }

  void _showUrlInputDialog() {
    final urlController = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          '输入视频地址',
          style: TextStyle(
            color: isDark ? AppColors.textOnDark : AppColors.textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '请输入有效的视频 URL（支持 mp4, m3u8 等格式）',
              style: TextStyle(
                color: isDark
                    ? AppColors.textOnDarkSecondary
                    : AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: urlController,
              decoration: const InputDecoration(
                hintText: 'https://example.com/video.mp4',
                labelText: '视频 URL',
              ),
              autofocus: true,
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
              final url = urlController.text.trim();
              if (url.isNotEmpty) {
                Navigator.pop(context);
                _playVideo(url);
              }
            },
            child: const Text('播放'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _player.dispose();
    // 恢复竖屏
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    // 恢复系统UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          setState(() {
            _showControls = !_showControls;
          });
        },
        child: Stack(
          children: [
            // 视频画面
            if (_isInitialized)
              Center(
                child: Video(controller: _controller),
              )
            else
              Center(
                child: _isLoading
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: AppColors.primaryLight,
                          ),
                          SizedBox(height: 16),
                          Text(
                            '正在加载视频...',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.movie_rounded,
                            color: Colors.white54,
                            size: 64,
                          ),
                          const SizedBox(height: 16),
                          if (_errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 32),
                              child: Text(
                                _errorMessage!,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          else
                            Text(
                              '暂无视频源',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 16,
                              ),
                            ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: _resolveAndPlay,
                                icon: const Icon(Icons.refresh_rounded),
                                label: const Text('重试'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryLight,
                                  foregroundColor: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 16),
                              ElevatedButton.icon(
                                onPressed: _showUrlInputDialog,
                                icon: const Icon(Icons.link_rounded),
                                label: const Text('手动输入'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white.withOpacity(0.2),
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
              ),

            // 返回按钮 - 始终显示
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              left: 8,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            // 控制层 - 仅在视频初始化后显示
            if (_showControls && _isInitialized)
              _buildControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildControls() {
    return StreamBuilder<Duration>(
      stream: _player.stream.position,
      builder: (context, positionSnapshot) {
        return StreamBuilder<Duration>(
          stream: _player.stream.duration,
          builder: (context, durationSnapshot) {
            final position = positionSnapshot.data ?? Duration.zero;
            final duration = durationSnapshot.data ?? Duration.zero;

            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                  stops: const [0, 0.3, 0.7, 1],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 顶部栏
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // 手动输入按钮
                        IconButton(
                          icon: const Icon(
                            Icons.link_rounded,
                            color: Colors.white,
                          ),
                          onPressed: _showUrlInputDialog,
                        ),
                      ],
                    ),
                  ),

                  // 中间播放按钮
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        iconSize: 48,
                        icon: const Icon(
                          Icons.replay_10_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          final newPos = position - const Duration(seconds: 10);
                          _player.seek(newPos.isNegative ? Duration.zero : newPos);
                        },
                      ),
                      const SizedBox(width: 32),
                      IconButton(
                        iconSize: 64,
                        icon: Icon(
                          _isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_filled,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _player.playOrPause();
                        },
                      ),
                      const SizedBox(width: 32),
                      IconButton(
                        iconSize: 48,
                        icon: const Icon(
                          Icons.forward_10_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          final newPos = position + const Duration(seconds: 10);
                          _player.seek(newPos > duration ? duration : newPos);
                        },
                      ),
                    ],
                  ),

                  // 底部控制栏
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
                    child: Column(
                      children: [
                        // 进度条
                        Row(
                          children: [
                            Text(
                              _formatDuration(position),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            Expanded(
                              child: Slider(
                                value: position.inMilliseconds.toDouble(),
                                min: 0,
                                max: duration.inMilliseconds.toDouble() > 0
                                    ? duration.inMilliseconds.toDouble()
                                    : 1,
                                onChanged: (value) {
                                  _player.seek(
                                    Duration(milliseconds: value.toInt()),
                                  );
                                },
                                activeColor: AppColors.accent,
                                inactiveColor: Colors.white30,
                              ),
                            ),
                            Text(
                              _formatDuration(duration),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),

                        // 功能按钮
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // 播放/暂停
                            IconButton(
                              icon: Icon(
                                _isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                _player.playOrPause();
                              },
                            ),

                            const SizedBox(width: 32),

                            // 倍速
                            StreamBuilder<double>(
                              stream: _player.stream.rate,
                              builder: (context, snapshot) {
                                final speed = snapshot.data ?? 1.0;
                                return PopupMenuButton<double>(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      '${speed}x',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  onSelected: (value) {
                                    _player.setRate(value);
                                  },
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 0.5,
                                      child: Text('0.5x'),
                                    ),
                                    const PopupMenuItem(
                                      value: 0.75,
                                      child: Text('0.75x'),
                                    ),
                                    const PopupMenuItem(
                                      value: 1.0,
                                      child: Text('1.0x'),
                                    ),
                                    const PopupMenuItem(
                                      value: 1.25,
                                      child: Text('1.25x'),
                                    ),
                                    const PopupMenuItem(
                                      value: 1.5,
                                      child: Text('1.5x'),
                                    ),
                                    const PopupMenuItem(
                                      value: 2.0,
                                      child: Text('2.0x'),
                                    ),
                                    const PopupMenuItem(
                                      value: 3.0,
                                      child: Text('3.0x'),
                                    ),
                                  ],
                                );
                              },
                            ),

                            const SizedBox(width: 32),

                            // 音量
                            StreamBuilder<double>(
                              stream: _player.stream.volume,
                              builder: (context, snapshot) {
                                final volume = snapshot.data ?? 100.0;
                                return Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        volume > 0
                                            ? Icons.volume_up
                                            : Icons.volume_off,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        _player.setVolume(
                                          volume > 0 ? 0 : 100,
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: Slider(
                                        value: volume,
                                        min: 0,
                                        max: 100,
                                        onChanged: (value) {
                                          _player.setVolume(value);
                                        },
                                        activeColor: Colors.white,
                                        inactiveColor: Colors.white30,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
