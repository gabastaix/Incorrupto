import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─────────────────────────────────────────────
//  LocaleService
//  Utilisé dans main.dart et dans la page profil
//  pour changer la langue de toute l'appli.
//
//  Utilisation :
//    final service = LocaleService();
//    await service.load();          // au démarrage
//    service.setLocale(Locale('en'));// pour changer
// ─────────────────────────────────────────────
class LocaleService extends ChangeNotifier {
  static const _key = 'app_locale';

  Locale _locale = const Locale('fr');

  Locale get locale => _locale;

  /// À appeler une fois dans main() avant runApp()
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final code  = prefs.getString(_key) ?? 'fr';
    _locale = Locale(code);
  }

  /// Sauvegarde et notifie l'appli entière
  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, locale.languageCode);
    notifyListeners();
  }

  String get currentLanguageName =>
      _locale.languageCode == 'fr' ? 'Français' : 'English';
}