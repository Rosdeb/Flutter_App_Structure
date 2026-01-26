import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pagedrop/Views/Base/AppText/appText.dart';
import 'package:pagedrop/controllers/localizations/localization_controller.dart';
import 'package:pagedrop/utils/AppConstant/app_contants.dart';

class LanguageSelector extends StatelessWidget {
  final bool showAsDropdown; // Whether to show as dropdown or as a list of flags
  final Function(Locale)? onLanguageChanged; // Callback when language is changed
  
  const LanguageSelector({
    super.key, 
    this.showAsDropdown = true, 
    this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final localizationController = Get.find<LocalizationController>();
    
    if (showAsDropdown) {
      return DropdownButton<Locale>(
        value: localizationController.locale,
        isExpanded: true,
        onChanged: (Locale? newValue) {
          if (newValue != null) {
            localizationController.setLanguage(newValue);
            if (onLanguageChanged != null) {
              onLanguageChanged!(newValue);
            }
          }
        },
        items: AppConstants.languages.map<DropdownMenuItem<Locale>>(
          (language) {
            return DropdownMenuItem<Locale>(
              value: Locale(language.languageCode, language.countryCode),
              child: AppText(
                language.languageName,
                fontSize: 16,
              ),
            );
          },
        ).toList(),
      );
    } else {
      // Show as flag buttons
      return Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: AppConstants.languages.map((language) {
          final locale = Locale(language.languageCode, language.countryCode);
          return ElevatedButton(
            onPressed: () {
              localizationController.setLanguage(locale);
              if (onLanguageChanged != null) {
                onLanguageChanged!(locale);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: localizationController.locale.languageCode == language.languageCode
                  ? Colors.blue
                  : Colors.grey.shade300,
              foregroundColor: localizationController.locale.languageCode == language.languageCode
                  ? Colors.white
                  : Colors.black,
            ),
            child: Text(
              getFlagEmoji(language.languageCode), // Show flag emoji
              style: const TextStyle(fontSize: 20),
            ),
          );
        }).toList(),
      );
    }
  }
  
  // Helper method to get flag emojis based on language codes
  String getFlagEmoji(String languageCode) {
    switch (languageCode.toLowerCase()) {
      case 'en':
        return '🇬🇧'; // UK flag for English
      case 'fr':
        return '🇫🇷'; // France flag for French
      case 'es':
        return '🇪🇸'; // Spain flag for Spanish
      case 'it':
        return '🇮🇹'; // Italy flag for Italian
      case 'de':
        return '🇩🇪'; // Germany flag for German
      case 'pt':
        return '🇵🇹'; // Portugal flag for Portuguese
      default:
        return '🌐'; // Globe for others
    }
  }
}