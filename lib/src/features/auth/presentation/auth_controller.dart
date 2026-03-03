import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/storage_service.dart';
import '../domain/auth_state.dart';
import '../data/auth_repository.dart';

part 'auth_controller.g.dart';

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  AuthState build() {
    // Note: Do NOT add ref.keepAlive() here; keepAlive: true already handles it.
    _init();
    return const AuthState();
  }

  Future<void> _init() async {
    final storage = ref.read(storageServiceProvider);
    final (access, refresh) = await storage.getTokens();

    // Check ref.mounted to ensure provider is still active after async call
    if (access != null && refresh != null && ref.mounted) {
      state = state.copyWith(accessToken: access, refreshToken: refresh);
    }
  }

  Future<void> login(String username, String password) async {
    state = state.copyWith(isLoading: true);
    try {
      final authResult = await ref
          .read(authRepositoryProvider)
          .login(username, password);

      // Save to storage
      await ref
          .read(storageServiceProvider)
          .saveTokens(authResult.accessToken!, authResult.refreshToken!);

      if (ref.mounted) {
        state = authResult;
      }
    } catch (e) {
      if (ref.mounted) {
        state = const AuthState();
      }
      rethrow;
    } finally {
      if (ref.mounted) {
        state = state.copyWith(isLoading: false);
      }
    }
  }

  void updateTokens(String access, String refresh) {
    ref.read(storageServiceProvider).saveTokens(access, refresh);
    state = state.copyWith(accessToken: access, refreshToken: refresh);
  }

  Future<void> logout() async {
    await ref.read(storageServiceProvider).clear();
    if (ref.mounted) {
      state = const AuthState();
    }
  }
}
