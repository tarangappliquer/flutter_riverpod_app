import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_app/src/core/theme/theme_controller.dart';

import '../../features/auth/presentation/auth_controller.dart';
import '../../features/auth/presentation/widgets/profile_header.dart';

class AppTheme {
  // 1. Light Theme Definition
  static ThemeData get lightTheme =>
      _baseTheme(brightness: Brightness.light, seedColor: Colors.blue);

  // 2. Dark Theme Definition
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

      // --- Global AppBar Styling ---
      appBarTheme: AppBarTheme(
        centerTitle: true,
        // In Material 3, dark app bars often look better with a deep surface color
        backgroundColor: isLight ? seedColor : null,
        foregroundColor: isLight ? Colors.white : null,
        elevation: 0,
      ),

      // --- Modern Input Styling ---
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        // Adjust fill color based on brightness for visibility
        fillColor: isLight
            ? Colors.grey.withValues(alpha: 0.1)
            : Colors.white.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(color: isLight ? Colors.black45 : Colors.white54),
      ),

      // --- Button Styling ---
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          // Using colorScheme ensures buttons look correct in both modes
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

  /// Returns the icon associated with the current ThemeMode
  static IconData getThemeIcon(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.system => Icons.brightness_auto,
      ThemeMode.light => Icons.light_mode,
      ThemeMode.dark => Icons.dark_mode,
    };
  }

  // Add this inside your AppTheme.showThemeSelector method
  static void showThemeSelector(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeControllerProvider);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. User Profile Section
            const ProfileHeader(),
            const Divider(),

            // 2. Theme Selection Header
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

            // ... (Existing _themeTile calls for System, Light, Dark) ...
            // const Padding(
            //   padding: EdgeInsets.all(16.0),
            //   child: Text(
            //     'Select Theme',
            //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            //   ),
            // ),
            _themeTile(
              context,
              ref,
              'System Default',
              Icons.brightness_auto,
              ThemeMode.system,
              currentTheme,
            ),
            _themeTile(
              context,
              ref,
              'Light Mode',
              Icons.light_mode,
              ThemeMode.light,
              currentTheme,
            ),
            _themeTile(
              context,
              ref,
              'Dark Mode',
              Icons.dark_mode,
              ThemeMode.dark,
              currentTheme,
            ),
            const Divider(),

            // 3. Logout Action
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.redAccent),
              ),
              onTap: () {
                Navigator.pop(context); // Close sheet
                ref.read(authControllerProvider.notifier).logout(); // Log out
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  static Widget _themeTile(
    BuildContext context,
    WidgetRef ref,
    String title,
    IconData icon,
    ThemeMode value,
    ThemeMode groupValue,
  ) {
    return RadioListTile<ThemeMode>(
      title: Text(title),
      secondary: Icon(icon),
      value: value,
      groupValue: groupValue,
      onChanged: (val) {
        ref.read(themeControllerProvider.notifier).setTheme(val!);
        Navigator.pop(context);
      },
    );
  }
}
