import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/colors.dart';
import '../../../data/models/kazumi_rule.dart';
import '../../../data/datasources/remote/rule_video_source.dart';
import '../../providers/video_providers.dart';

/// 规则管理页面
class RuleManagerPage extends ConsumerStatefulWidget {
  const RuleManagerPage({super.key});

  @override
  ConsumerState<RuleManagerPage> createState() => _RuleManagerPageState();
}

class _RuleManagerPageState extends ConsumerState<RuleManagerPage> {
  final List<KazumiRule> _rules = [...PresetRules.all];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('规则管理'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => _showAddRuleDialog(),
          ),
          IconButton(
            icon: const Icon(Icons.paste_rounded),
            onPressed: () => _importFromClipboard(),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _rules.length,
        itemBuilder: (context, index) {
          final rule = _rules[index];
          return _buildRuleCard(rule, isDark);
        },
      ),
    );
  }

  Widget _buildRuleCard(KazumiRule rule, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.rule_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
        title: Text(
          rule.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textOnDark : AppColors.textPrimary,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '版本: ${rule.version}',
              style: TextStyle(
                color: isDark
                    ? AppColors.textOnDarkSecondary
                    : AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              rule.baseUrl,
              style: TextStyle(
                color: isDark
                    ? AppColors.textOnDarkSecondary
                    : AppColors.textHint,
                fontSize: 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        trailing: PopupMenuButton(
          icon: Icon(
            Icons.more_vert_rounded,
            color: isDark
                ? AppColors.textOnDarkSecondary
                : AppColors.textSecondary,
          ),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'use',
              child: Row(
                children: [
                  Icon(Icons.play_circle_outline_rounded),
                  SizedBox(width: 8),
                  Text('使用此规则'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit_rounded),
                  SizedBox(width: 8),
                  Text('编辑规则'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'export',
              child: Row(
                children: [
                  Icon(Icons.copy_rounded),
                  SizedBox(width: 8),
                  Text('复制规则'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_rounded, color: Colors.red),
                  SizedBox(width: 8),
                  Text('删除规则', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          onSelected: (value) => _handleRuleAction(value, rule),
        ),
        onTap: () => _useRule(rule),
      ),
    );
  }

  void _handleRuleAction(String action, KazumiRule rule) {
    switch (action) {
      case 'use':
        _useRule(rule);
        break;
      case 'edit':
        _showEditRuleDialog(rule);
        break;
      case 'export':
        _exportToClipboard(rule);
        break;
      case 'delete':
        _deleteRule(rule);
        break;
    }
  }

  void _useRule(KazumiRule rule) {
    // 添加规则视频源到视频源列表
    final videoSource = RuleVideoSource(rule);
    ref.read(videoSourcesProvider.notifier).addSource(videoSource);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('已添加规则: ${rule.name}')),
    );
    
    Navigator.pop(context);
  }

  void _deleteRule(KazumiRule rule) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除规则'),
        content: Text('确定要删除规则 "${rule.name}" 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _rules.remove(rule);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('已删除规则: ${rule.name}')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  void _exportToClipboard(KazumiRule rule) {
    Clipboard.setData(ClipboardData(text: rule.toText()));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('已复制规则 "${rule.name}" 到剪贴板')),
    );
  }

  Future<void> _importFromClipboard() async {
    try {
      final data = await Clipboard.getData(Clipboard.kTextPlain);
      if (data?.text == null || data!.text!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('剪贴板为空')),
        );
        return;
      }

      final rule = KazumiRule.fromText(data.text!);
      setState(() {
        _rules.add(rule);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('已导入规则: ${rule.name}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('导入失败: $e')),
      );
    }
  }

  void _showAddRuleDialog() {
    final nameController = TextEditingController();
    final versionController = TextEditingController(text: '1.0');
    final baseUrlController = TextEditingController();
    final searchUrlController = TextEditingController();
    final searchListController = TextEditingController();
    final searchNameController = TextEditingController();
    final searchResultController = TextEditingController();
    final chapterRoadsController = TextEditingController();
    final chapterResultController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('添加规则'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: '规则名称'),
              ),
              TextField(
                controller: versionController,
                decoration: const InputDecoration(labelText: '版本号'),
              ),
              TextField(
                controller: baseUrlController,
                decoration: const InputDecoration(labelText: '网站基础 URL'),
              ),
              TextField(
                controller: searchUrlController,
                decoration: const InputDecoration(
                  labelText: '搜索 URL',
                  hintText: '使用 @keyword 作为关键词占位符',
                ),
              ),
              TextField(
                controller: searchListController,
                decoration: const InputDecoration(labelText: '搜索结果列表 Xpath'),
              ),
              TextField(
                controller: searchNameController,
                decoration: const InputDecoration(labelText: '番剧名称 Xpath'),
              ),
              TextField(
                controller: searchResultController,
                decoration: const InputDecoration(labelText: '详情页链接 Xpath'),
              ),
              TextField(
                controller: chapterRoadsController,
                decoration: const InputDecoration(labelText: '分集列表容器 Xpath'),
              ),
              TextField(
                controller: chapterResultController,
                decoration: const InputDecoration(labelText: '分集链接 Xpath'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              final rule = KazumiRule(
                name: nameController.text,
                version: versionController.text,
                baseUrl: baseUrlController.text,
                searchUrl: searchUrlController.text,
                searchList: searchListController.text,
                searchName: searchNameController.text,
                searchResult: searchResultController.text,
                chapterRoads: chapterRoadsController.text,
                chapterResult: chapterResultController.text,
              );

              setState(() {
                _rules.add(rule);
              });

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('已添加规则: ${rule.name}')),
              );
            },
            child: const Text('添加'),
          ),
        ],
      ),
    );
  }

  void _showEditRuleDialog(KazumiRule rule) {
    final nameController = TextEditingController(text: rule.name);
    final versionController = TextEditingController(text: rule.version);
    final baseUrlController = TextEditingController(text: rule.baseUrl);
    final searchUrlController = TextEditingController(text: rule.searchUrl);
    final searchListController = TextEditingController(text: rule.searchList);
    final searchNameController = TextEditingController(text: rule.searchName);
    final searchResultController = TextEditingController(text: rule.searchResult);
    final chapterRoadsController = TextEditingController(text: rule.chapterRoads);
    final chapterResultController = TextEditingController(text: rule.chapterResult);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('编辑规则'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: '规则名称'),
              ),
              TextField(
                controller: versionController,
                decoration: const InputDecoration(labelText: '版本号'),
              ),
              TextField(
                controller: baseUrlController,
                decoration: const InputDecoration(labelText: '网站基础 URL'),
              ),
              TextField(
                controller: searchUrlController,
                decoration: const InputDecoration(
                  labelText: '搜索 URL',
                  hintText: '使用 @keyword 作为关键词占位符',
                ),
              ),
              TextField(
                controller: searchListController,
                decoration: const InputDecoration(labelText: '搜索结果列表 Xpath'),
              ),
              TextField(
                controller: searchNameController,
                decoration: const InputDecoration(labelText: '番剧名称 Xpath'),
              ),
              TextField(
                controller: searchResultController,
                decoration: const InputDecoration(labelText: '详情页链接 Xpath'),
              ),
              TextField(
                controller: chapterRoadsController,
                decoration: const InputDecoration(labelText: '分集列表容器 Xpath'),
              ),
              TextField(
                controller: chapterResultController,
                decoration: const InputDecoration(labelText: '分集链接 Xpath'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              final updatedRule = rule.copyWith(
                name: nameController.text,
                version: versionController.text,
                baseUrl: baseUrlController.text,
                searchUrl: searchUrlController.text,
                searchList: searchListController.text,
                searchName: searchNameController.text,
                searchResult: searchResultController.text,
                chapterRoads: chapterRoadsController.text,
                chapterResult: chapterResultController.text,
              );

              setState(() {
                final index = _rules.indexOf(rule);
                if (index != -1) {
                  _rules[index] = updatedRule;
                }
              });

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('已更新规则: ${updatedRule.name}')),
              );
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }
}
