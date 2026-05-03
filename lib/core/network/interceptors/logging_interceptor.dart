import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// 日志拦截器
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      print('┌──────────────────────────────────────────');
      print('│ Request: ${options.method} ${options.uri}');
      print('│ Headers: ${options.headers}');
      if (options.data != null) {
        print('│ Data: ${options.data}');
      }
      print('└──────────────────────────────────────────');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print('┌──────────────────────────────────────────');
      print('│ Response: ${response.statusCode} ${response.requestOptions.uri}');
      print('│ Data: ${response.data}');
      print('└──────────────────────────────────────────');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      print('┌──────────────────────────────────────────');
      print('│ Error: ${err.type} ${err.requestOptions.uri}');
      print('│ Message: ${err.message}');
      print('└──────────────────────────────────────────');
    }
    handler.next(err);
  }
}
