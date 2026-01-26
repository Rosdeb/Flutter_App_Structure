import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/AppConstant/app_contants.dart';
import '../../utils/AppColor/app_colors.dart';

class ThemeController extends GetxController implements GetxService {
  final SharedPreferences sharedPreferences;

  ThemeController({required this.sharedPreferences}) {
    _loadCurrentTheme();
  }

  bool _darkTheme = false;
  bool get darkTheme => _darkTheme;

  var darkThemeObs = false.obs;

  @override
  void onInit() {
    super.onInit();

    ever(darkThemeObs, (isDark) async {
      if (kDebugMode) print("🎨 ThemeController: Theme changed to $isDark");

    });
  }

  void toggleTheme() {
    if (kDebugMode) print("🔄 toggleTheme called");
    _darkTheme = !_darkTheme;
    darkThemeObs.value = _darkTheme;
    sharedPreferences.setBool(AppConstants.THEME, _darkTheme);
    update();
  }

  void setTheme(bool isDark) {
    if (kDebugMode) print("🔄 setTheme called with: $isDark");
    _darkTheme = isDark;
    darkThemeObs.value = isDark;
    sharedPreferences.setBool(AppConstants.THEME, _darkTheme);
    update();
  }

  void changeTheme(Color lightColor, Color darkColor) {
    update();
  }

  void _loadCurrentTheme() async {
    _darkTheme = sharedPreferences.getBool(AppConstants.THEME) ?? false;
    darkThemeObs.value = _darkTheme;
    if (kDebugMode) {
      print("📱 Theme loaded from storage: $_darkTheme");
    }
    update();
  }

  Color get backgroundColor => _darkTheme ? AppColors.DarkThemeBackground : Colors.white;
  Color get surfaceColor => _darkTheme ? AppColors.DarkThemeSurface : Colors.white;
  Color get textColor => _darkTheme ? AppColors.DarkThemeText : AppColors.Black;
  Color get appBarColor => _darkTheme ? AppColors.DarkThemeAppBar : Colors.white;
}