import 'package:shared_preferences/shared_preferences.dart';

class NotificationPreferencesService {
  static const String _keyNewArticles = 'notification_new_articles';
  static const String _keyAppAlert = 'notification_app_alert';

  // sigleton
  static final NotificationPreferencesService _instance =
      NotificationPreferencesService._internal();

  factory NotificationPreferencesService() => _instance;

  NotificationPreferencesService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<bool> setAppAlert(bool value) async {
    await init();
    return await _prefs!.setBool(_keyAppAlert, value);
  }

  /// Get App Alert notification state
  Future<bool> getAppAlert() async {
    await init();
    return _prefs!.getBool(_keyAppAlert) ?? false;
  }
  Future<bool> setNewArticles(bool value) async {
    await init();
    return await _prefs!.setBool(_keyNewArticles, value);
  }
  Future<bool> getNewArticles() async {
    await init();
    return _prefs!.getBool(_keyNewArticles) ?? false;
  }

  Future<Map<String, bool>> getAllNotificationState()async{
    await init();
    return {
      'newArticles': await getNewArticles(),
      'appAlert': await getAppAlert(),
    };

  }

  Future<bool> cleanAll()async{
    await init();
    await _prefs!.remove(_keyAppAlert);
    await _prefs!.remove(_keyNewArticles);
    return true;
  }

  Future<void> setAllNotificationStates({
    required bool breakingNews,
    required bool newArticles,
    required bool appAlert,
  }) async {
    await init();
    await _prefs!.setBool(_keyNewArticles, newArticles);
    await _prefs!.setBool(_keyAppAlert, appAlert);
  }


}
