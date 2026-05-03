import 'package:dio/dio.dart';

/// 重试拦截器
class RetryInterceptor extends Interceptor {
  final int maxRetries;
  final Duration retryInterval;

  RetryInterceptor({
    this.maxRetries = 3,
    this.retryInterval = const Duration(seconds: 1),
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final retryCount = err.requestOptions.extra['retryCount'] ?? 0;

    if (retryCount < maxRetries && _shouldRetry(err)) {
      final newRetryCount = retryCount + 1;
      err.requestOptions.extra['retryCount'] = newRetryCount;

      // 指数退避
      final delay = retryInterval * newRetryCount;
      await Future.delayed(delay);

      try {
        final dio = Dio();
        final response = await dio.fetch(err.requestOptions);
        handler.resolve(response);
      } catch (e) {
        handler.next(err);
      }
    } else {
      handler.next(err);
    }
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        (err.response?.statusCode == 500) ||
        (err.response?.statusCode == 502) ||
        (err.response?.statusCode == 503);
  }
}
