import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../network/storage_service.dart';

part 'theme_controller.g.dart';

@Riverpod(keepAlive: true)
class ThemeController extends _$ThemeController {
  @override
  ThemeMode build() {
    // We don't 'await' here to keep build() synchronous for the initial return
    _loadTheme();
    return ThemeMode.system;
  }

  Future<void> _loadTheme() async {
    final storage = ref.read(storageServiceProvider);
    final savedTheme = await storage.getTheme();

    if (savedTheme != null && ref.mounted) {
      state = ThemeMode.values.firstWhere(
        (e) => e.name == savedTheme,
        orElse: () => ThemeMode.system,
      );
    }
  }

  Future<void> setTheme(ThemeMode mode) async {
    if (state == mode) return;

    state = mode;
    await ref.read(storageServiceProvider).saveTheme(mode.name);
  }
}
