import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/dio_provider.dart';
import '../domain/auth_state.dart';

part 'auth_repository.g.dart';

// Change @riverpod to @Riverpod(keepAlive: true)
@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) =>
    AuthRepository(ref.watch(dioProvider));

class AuthRepository {
  final Dio _dio;
  AuthRepository(this._dio);

  Future<AuthState> login(String username, String password) async {
    final res = await _dio.post(
      '/auth/login',
      data: {'username': username, 'password': password},
    );
    return AuthState.fromJson(res.data).copyWith(user: User.fromJson(res.data));
  }

  Future<Map<String, String>> refresh(String refreshToken) async {
    final res = await _dio.post(
      '/auth/refresh',
      data: {'refreshToken': refreshToken},
    );
    return {
      'accessToken': res.data['accessToken'],
      'refreshToken': res.data['refreshToken'],
    };
  }
}
