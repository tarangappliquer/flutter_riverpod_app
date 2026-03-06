import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_app/src/core/theme/theme_controller.dart';

import '../../features/auth/presentation/auth_controller.dart';
import '../../features/auth/presentation/widgets/profile_header.dart';

class AppTheme {
  static ThemeData get lightTheme =>
      _baseTheme(brightness: Brightness.light, seedColor: Colors.blue);

  static ThemeData get darkTheme =>
      _baseTheme(brightness: Brightness.dark, seedColor: Colors.blue);

  static ThemeData _baseTheme({
    required Brightness brightness,
    required Color seedColor,
  }) {
    final isLight = brightness == Brightness.light;

    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: seedColor,
      brightness: brightness,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: isLight ? seedColor : null,
        foregroundColor: isLight ? Colors.white : null,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isLight
            ? Colors.grey.withValues(alpha: 0.1)
            : Colors.white.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(color: isLight ? Colors.black45 : Colors.white54),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: isLight ? seedColor : null,
          foregroundColor: isLight ? Colors.white : null,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  static IconData getThemeIcon(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.system => Icons.brightness_auto,
      ThemeMode.light => Icons.light_mode,
      ThemeMode.dark => Icons.dark_mode,
    };
  }

  static void showThemeSelector(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeControllerProvider);

    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ProfileHeader(),
              // const Divider(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Appearance',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              RadioGroup<ThemeMode>(
                groupValue: currentTheme,
                onChanged: (val) {
                  if (val != null) {
                    ref.read(themeControllerProvider.notifier).setTheme(val);
                    Navigator.pop(context);
                  }
                },
                child: Column(
                  children: [
                    _themeTile(
                      'System Default',
                      Icons.brightness_auto,
                      ThemeMode.system,
                    ),
                    _themeTile('Light Mode', Icons.light_mode, ThemeMode.light),
                    _themeTile('Dark Mode', Icons.dark_mode, ThemeMode.dark),
                  ],
                ),
              ),

              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  ref.read(authControllerProvider.notifier).logout();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _themeTile(String title, IconData icon, ThemeMode value) {
    return RadioListTile<ThemeMode>(
      title: Text(title),
      secondary: Icon(icon),
      value: value,
    );
  }
}
