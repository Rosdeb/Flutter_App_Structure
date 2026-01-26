import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pagedrop/controllers/Theme/theme_controller.dart';
import 'package:pagedrop/controllers/localizations/localization_controller.dart';
import 'package:pagedrop/utils/AppConstant/app_contants.dart';
import 'package:pagedrop/utils/Message/message.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Helpers/di.dart' as di;
import 'Helpers/route.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);

  // Initialize all services through the service manage

  final prefs = await SharedPreferences.getInstance();
  Get.put(LocalizationController(sharedPreferences: prefs), permanent: true);
  Map<String, Map<String, String>> languages = await di.init();
  Get.put(ThemeController(sharedPreferences: prefs), permanent: true);
  runApp(MyApp(languages: languages));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.languages});
  final Map<String, Map<String, String>> languages;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocalizationController>(
      builder: (localizeController) {
        return GetBuilder<ThemeController>(
          builder: (themeController) {
            return ScreenUtilInit(
              designSize: const Size(393, 852),
              minTextAdapt: true,
              builder: (context, child) {
                return GetMaterialApp(
                  debugShowCheckedModeBanner: false,
                  locale: localizeController.locale,
                  translations: Messages(languages: languages),
                  fallbackLocale: Locale(
                    AppConstants.languages[0].languageCode,
                    AppConstants.languages[0].countryCode,
                  ),
                  theme: themeController.darkTheme
                    ? ThemeData(
                        fontFamily: "Inter",
                        brightness: Brightness.dark,
                        primarySwatch: Colors.blue,
                        primaryColor: const Color(0xFF1593E5),
                        scaffoldBackgroundColor: const Color(0xFF2a2a2a),
                        appBarTheme: const AppBarTheme(
                          backgroundColor: Color(0xFF2a2a2a),
                          foregroundColor: Colors.white,
                        ),
                        textTheme: const TextTheme(
                          bodyLarge: TextStyle(color: Colors.white),
                          bodyMedium: TextStyle(color: Colors.white),
                          bodySmall: TextStyle(color: Colors.white),
                          titleLarge: TextStyle(color: Colors.white),
                          titleMedium: TextStyle(color: Colors.white),
                          titleSmall: TextStyle(color: Colors.white),
                        ),
                        colorScheme: ColorScheme.fromSwatch().copyWith(
                          brightness: Brightness.dark,
                          secondary: const Color(0xFFe32b6b),
                        ),
                      )
                    : ThemeData(
                        fontFamily: "Inter",
                        brightness: Brightness.light,
                        primarySwatch: Colors.blue,
                        primaryColor: const Color(0xFF1593E5),
                        scaffoldBackgroundColor: Colors.white,
                        appBarTheme: const AppBarTheme(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                        textTheme: const TextTheme(
                          bodyLarge: TextStyle(color: Colors.black),
                          bodyMedium: TextStyle(color: Colors.black),
                          bodySmall: TextStyle(color: Colors.black),
                          titleLarge: TextStyle(color: Colors.black),
                          titleMedium: TextStyle(color: Colors.black),
                          titleSmall: TextStyle(color: Colors.black),
                        ),
                        colorScheme: ColorScheme.fromSwatch().copyWith(
                          brightness: Brightness.light,
                          secondary: const Color(0xFFe32b6b),
                        ),
                      ),
                  getPages: AppRoutes.page,
                  initialRoute: AppRoutes.splashScreen,
                );
              },
            );
          },
        );
      },
    );
  }
}