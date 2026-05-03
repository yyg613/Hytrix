/// API 接口定义
abstract class ApiInterfaces {
  /// 获取每日放送
  Future<Map<String, dynamic>> getCalendar();

  /// 获取条目信息
  Future<Map<String, dynamic>> getSubject(int id);

  /// 获取条目剧集
  Future<Map<String, dynamic>> getEpisodes(int subjectId);

  /// 搜索条目
  Future<Map<String, dynamic>> searchSubjects(String keyword);
}
