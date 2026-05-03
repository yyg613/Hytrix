/// 统一错误类型定义
/// 
/// 所有业务逻辑层的错误都应转换为 Failure 类型
abstract class Failure {
  final String message;
  final int? statusCode;

  const Failure({required this.message, this.statusCode});

  @override
  String toString() => 'Failure(message: $message, statusCode: $statusCode)';
}

/// 网络请求失败
class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.statusCode});
}

/// 缓存读写失败
class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

/// 数据解析失败
class ParseFailure extends Failure {
  const ParseFailure({required super.message});
}

/// 数据源请求失败
class SourceFailure extends Failure {
  const SourceFailure({required super.message});
}

/// 未知错误
class UnknownFailure extends Failure {
  const UnknownFailure({required super.message});
}
