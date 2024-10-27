import 'dart:ffi';

import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppTheme {
  light,
  dark,
}

class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier() : super(false);

  void toggleTheme(bool istrue) {
    state = istrue;
  }
}

final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier();
});
