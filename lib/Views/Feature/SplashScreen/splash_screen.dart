import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pagedrop/Views/Base/AppText/appText.dart';
import 'package:pagedrop/Views/Base/LanguageSelector/language_selector.dart';
import 'package:pagedrop/controllers/localizations/localization_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizationController = Get.find<LocalizationController>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Main content
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText(
                      "Welcome to Pagedrop".tr, // Using translation key
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      color: Colors.black,
                    ),
                    const SizedBox(height: 20),
                    AppText(
                      "Log in".tr,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),

            // Language selection section
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    "Language Preferences".tr,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  const SizedBox(height: 10),

                  // Language selection dropdown
                  LanguageSelector(
                    showAsDropdown: true,
                    onLanguageChanged: (locale) {
                      // Optional callback when language changes
                      print('Language changed to: ${locale.languageCode}');
                    },
                  ),

                  const SizedBox(height: 20),

                  // Alternative language buttons with flags
                  LanguageSelector(
                    showAsDropdown: false,
                    onLanguageChanged: (locale) {
                      // Optional callback when language changes
                      print('Language changed to: ${locale.languageCode}');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
