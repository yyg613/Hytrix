/// 自定义异常基类
abstract class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException({required this.message, this.statusCode});

  @override
  String toString() => 'AppException(message: $message, statusCode: $statusCode)';
}

/// 网络请求异常
class NetworkException extends AppException {
  const NetworkException({required super.message, super.statusCode});
}

/// 缓存异常
class CacheException extends AppException {
  const CacheException({required super.message});
}

/// 解析异常
class ParseException extends AppException {
  const ParseException({required super.message});
}

/// 数据源异常
class SourceException extends AppException {
  const SourceException({required super.message});
}
