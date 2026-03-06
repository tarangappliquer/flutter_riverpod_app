import 'package:dio/dio.dart';
import 'package:flutter_riverpod_app/flavors.dart';
import 'package:flutter_riverpod_app/src/core/network/auth_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_provider.g.dart';

@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final options = BaseOptions(
    baseUrl: 'https://dummyjson.com',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  );

  final dio = Dio(options);
  // Add our custom Auth Interceptor
  dio.interceptors.add(AuthInterceptor(ref));
  if (F.appFlavor != Flavor.prod) {
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        compact: false,
      ),
    );
  }

  return dio;
}
