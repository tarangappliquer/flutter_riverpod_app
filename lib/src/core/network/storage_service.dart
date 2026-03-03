import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'storage_service.g.dart';

@Riverpod(keepAlive: true)
StorageService storageService(Ref ref) => StorageService();

class StorageService {
  final _storage = const FlutterSecureStorage();

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _themeKey = 'user_theme_mode';

  Future<void> saveTokens(String access, String refresh) async {
    await _storage.write(key: _accessTokenKey, value: access);
    await _storage.write(key: _refreshTokenKey, value: refresh);
  }

  Future<(String?, String?)> getTokens() async {
    final access = await _storage.read(key: _accessTokenKey);
    final refresh = await _storage.read(key: _refreshTokenKey);
    return (access, refresh);
  }

  // Save the theme preference (light, dark, or system)
  Future<void> saveTheme(String themeName) async {
    await _storage.write(key: _themeKey, value: themeName);
  }

  // Retrieve the theme preference
  Future<String?> getTheme() async {
    return await _storage.read(key: _themeKey);
  }

  Future<void> clear() async {
    await _storage.deleteAll();
  }
}
