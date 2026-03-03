import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/auth_controller.dart';
import '../../features/auth/data/auth_repository.dart';

class AuthInterceptor extends Interceptor {
  final Ref ref;
  AuthInterceptor(this.ref);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final authState = ref.read(authControllerProvider);
    if (authState.accessToken != null) {
      options.headers['Authorization'] = 'Bearer ${authState.accessToken}';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = ref.read(authControllerProvider).refreshToken;

      if (refreshToken != null) {
        try {
          final newTokens = await ref
              .read(authRepositoryProvider)
              .refresh(refreshToken);

          ref
              .read(authControllerProvider.notifier)
              .updateTokens(
                newTokens['accessToken']!,
                newTokens['refreshToken']!,
              );

          final opts = err.requestOptions;
          opts.headers['Authorization'] = 'Bearer ${newTokens['accessToken']}';

          final cloneReq = await Dio(
            BaseOptions(baseUrl: opts.baseUrl),
          ).fetch(opts);
          return handler.resolve(cloneReq);
        } catch (e) {
          ref.read(authControllerProvider.notifier).logout();
        }
      }
    }
    handler.next(err);
  }
}
