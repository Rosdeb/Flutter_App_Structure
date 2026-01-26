# Pagedrop App - Language Change Functionality Guide

## Overview
This document explains how to use the language change functionality in the Pagedrop app. The app supports multiple languages (English, French, Spanish, Italian, German, Portuguese) and allows users to switch between them dynamically.

## Features Implemented

### 1. Language Selection in Splash Screen
- Added language selection dropdown
- Added flag-based language selection buttons
- Real-time language switching capability

### 2. Reusable Language Selector Component
- Created `LanguageSelector` widget for consistent language selection UI
- Supports both dropdown and flag button modes
- Callback support for handling language changes

### 3. Updated Translation Files
- Added "Welcome to Pagedrop" translation to all language files
- Maintained consistency across all supported languages

## How to Use Language Change Functionality

### Step 1: Understanding the Architecture

The language change system consists of:

1. **Localization Controller** (`lib/controllers/localizations/localization_controller.dart`)
   - Manages current language state
   - Handles saving/loading language preferences
   - Updates the UI when language changes

2. **Translation Files** (`assets/language/*.json`)
   - Store key-value pairs for translations
   - One file per supported language

3. **App Constants** (`lib/utils/AppConstant/app_contants.dart`)
   - Defines supported languages
   - Contains language metadata

### Step 2: Using Translated Text

To use translated text in your widgets:

```dart
// Import required packages
import 'package:get/get.dart';
import 'package:pagedrop/Views/Base/AppText/appText.dart';

// Use .tr extension to translate text
AppText("Log in".tr)
```

### Step 3: Changing Language Programmatically

To change language programmatically:

```dart
import 'package:get/get.dart';
import 'package:pagedrop/controllers/localizations/localization_controller.dart';

final localizationController = Get.find<LocalizationController>();
localizationController.setLanguage(Locale('fr', 'FR')); // Change to French
```

### Step 4: Adding New Languages

To add a new language:

1. Add the language to `AppConstants.languages` list:
   ```dart
   static List<LanguageModel> languages = [
     // ... existing languages
     LanguageModel(languageName: 'Japanese', countryCode: 'JP', languageCode: 'ja'),
   ];
   ```

2. Create a new JSON file in `assets/language/` folder (e.g., `ja.json`)
3. Add all required translation keys to the new language file
4. The language will automatically appear in the selection dropdown

### Step 5: Using the LanguageSelector Widget

The `LanguageSelector` widget can be used anywhere in the app:

```dart
import 'package:pagedrop/Views/Base/LanguageSelector/language_selector.dart';

// Dropdown mode
LanguageSelector(
  showAsDropdown: true,
  onLanguageChanged: (locale) {
    print('Language changed to: ${locale.languageCode}');
  },
)

// Flag buttons mode
LanguageSelector(
  showAsDropdown: false,
  onLanguageChanged: (locale) {
    print('Language changed to: ${locale.languageCode}');
  },
)
```

### Step 6: Adding New Translation Keys

To add new translatable text:

1. Add the key-value pair to all language files in `assets/language/`:
   ```json
   {
     "New Feature": "New Feature",
     "Welcome Message": "Welcome to our app!"
   }
   ```

2. Use the key in your code with `.tr` extension:
   ```dart
   AppText("New Feature".tr)
   AppText("Welcome Message".tr)
   ```

## Best Practices

1. **Always use `.tr` extension** for text that needs to be translated
2. **Add new translations to all language files** to maintain consistency
3. **Use meaningful keys** in translation files (preferably in English)
4. **Test language switching** in different parts of the app
5. **Consider RTL languages** if supporting right-to-left scripts

## Troubleshooting

### Language not changing?
- Make sure the LocalizationController is properly initialized
- Check that the locale exists in AppConstants.languages
- Verify the translation key exists in the language file

### Missing translations?
- Ensure all language files contain the same keys
- Check for typos in translation keys
- Verify the JSON files are properly formatted

### UI not updating?
- Make sure GetX state management is working properly
- Check that the widget rebuilds when language changes
- Verify the translation key matches exactly in the JSON file

## Files Modified

- `lib/Views/Feature/SplashScreen/splash_screen.dart` - Enhanced with language selection
- `lib/Views/Base/LanguageSelector/language_selector.dart` - New reusable component
- `assets/language/*.json` - Added "Welcome to Pagedrop" translations
- `lib/Helpers/route.dart` - Fixed route names

## Conclusion

The language change functionality is now fully integrated into the Pagedrop app. Users can switch between supported languages seamlessly, and developers can easily add new languages or translation keys following the documented steps.