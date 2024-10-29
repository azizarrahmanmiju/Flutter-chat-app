import 'package:shared_preferences/shared_preferences.dart';

Future<void> settheme(bool isLightMode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('light', isLightMode);
  print("Theme saved as: $isLightMode");
}

Future<bool> getthem() async {
  final prefs = await SharedPreferences.getInstance();
  bool theme = prefs.getBool('light') ?? false;
  print("Theme loaded as: $theme");
  return theme;
}
