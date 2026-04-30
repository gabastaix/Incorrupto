import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemePreference { light, dark }

class AppSettingsService extends ChangeNotifier {
  AppThemePreference _themePreference = AppThemePreference.light;
  double _textScale = 1.0;
  bool _highContrast = false;
  bool _reduceMotion = false;

  bool _pushBreakingNews = true;
  bool _emailNewsletter = true;
  bool _topicAlerts = true;

  bool _showSummaries = true;
  bool _showFullArticles = false;
  bool _showAudio = false;

  AppThemePreference get themePreference => _themePreference;
  double get textScale => _textScale;
  bool get highContrast => _highContrast;
  bool get reduceMotion => _reduceMotion;

  bool get pushBreakingNews => _pushBreakingNews;
  bool get emailNewsletter => _emailNewsletter;
  bool get topicAlerts => _topicAlerts;

  bool get showSummaries => _showSummaries;
  bool get showFullArticles => _showFullArticles;
  bool get showAudio => _showAudio;

  ThemeMode get themeMode {
    switch (_themePreference) {
      case AppThemePreference.light:
        return ThemeMode.light;
      case AppThemePreference.dark:
        return ThemeMode.dark;
    }
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    final themeRaw = prefs.getString('theme_preference') ?? 'light';
    _themePreference = themeRaw == 'dark'
        ? AppThemePreference.dark
        : AppThemePreference.light;

    _textScale = prefs.getDouble('text_scale') ?? 1.0;
    _highContrast = prefs.getBool('high_contrast') ?? false;
    _reduceMotion = prefs.getBool('reduce_motion') ?? false;

    _pushBreakingNews = prefs.getBool('push_breaking_news') ?? true;
    _emailNewsletter = prefs.getBool('email_newsletter') ?? true;
    _topicAlerts = prefs.getBool('topic_alerts') ?? true;

    _showSummaries = prefs.getBool('show_summaries') ?? true;
    _showFullArticles = prefs.getBool('show_full_articles') ?? false;
    _showAudio = prefs.getBool('show_audio') ?? false;

    notifyListeners();
  }

  Future<void> setThemePreference(AppThemePreference preference) async {
    _themePreference = preference;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'theme_preference',
      preference == AppThemePreference.dark ? 'dark' : 'light',
    );
    notifyListeners();
  }

  Future<void> setTextScale(double value) async {
    _textScale = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('text_scale', value);
    notifyListeners();
  }

  Future<void> setHighContrast(bool value) async {
    _highContrast = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('high_contrast', value);
    notifyListeners();
  }

  Future<void> setReduceMotion(bool value) async {
    _reduceMotion = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('reduce_motion', value);
    notifyListeners();
  }

  Future<void> setPushBreakingNews(bool value) async {
    _pushBreakingNews = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('push_breaking_news', value);
    notifyListeners();
  }

  Future<void> setEmailNewsletter(bool value) async {
    _emailNewsletter = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('email_newsletter', value);
    notifyListeners();
  }

  Future<void> setTopicAlerts(bool value) async {
    _topicAlerts = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('topic_alerts', value);
    notifyListeners();
  }

  Future<void> setShowSummaries(bool value) async {
    _showSummaries = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('show_summaries', value);
    notifyListeners();
  }

  Future<void> setShowFullArticles(bool value) async {
    _showFullArticles = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('show_full_articles', value);
    notifyListeners();
  }

  Future<void> setShowAudio(bool value) async {
    _showAudio = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('show_audio', value);
    notifyListeners();
  }
}