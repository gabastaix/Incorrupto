import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../design/figma_contract.dart';
import '../design/screen_map.dart';
import '../screens/details/details_screen.dart';
import '../screens/login/login_screen.dart';
import '../services/app_settings_service.dart';
import '../services/locale_service.dart';
import '../l10n/app_strings.dart';
import 'shell.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool _isLoggedIn = false;
  String _userName = '';

  final LocaleService _localeService = LocaleService();
  final AppSettingsService _appSettingsService = AppSettingsService();

  bool _localeLoaded = false;
  bool _settingsLoaded = false;

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    await Future.wait([
      _localeService.load(),
      _appSettingsService.load(),
    ]);

    _localeService.addListener(_rebuildSafely);
    _appSettingsService.addListener(_rebuildSafely);

    if (mounted) {
      setState(() {
        _localeLoaded = true;
        _settingsLoaded = true;
      });
    }
  }

  void _rebuildSafely() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _localeService.removeListener(_rebuildSafely);
    _appSettingsService.removeListener(_rebuildSafely);
    _localeService.dispose();
    _appSettingsService.dispose();
    super.dispose();
  }

  void _login(String userName) {
    setState(() {
      _isLoggedIn = true;
      _userName = userName;
    });
  }

  void _logout() {
    setState(() {
      _isLoggedIn = false;
      _userName = '';
    });
  }

  ThemeData _buildLightTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: FigmaContract.fontFamily,
    scaffoldBackgroundColor: FigmaContract.bg,
    colorScheme: ColorScheme.light(
      primary: FigmaContract.primary,
      secondary: FigmaContract.primary,
      surface: FigmaContract.surface,
      error: FigmaContract.danger,
      onPrimary: Colors.white,
      onSurface: FigmaContract.textPrimary,
    ),
    dividerColor: FigmaContract.border,
    cardColor: FigmaContract.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: FigmaContract.bg,
      foregroundColor: FigmaContract.textPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: FigmaContract.body(),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return FigmaContract.primary;
        }
        return Colors.white;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return FigmaContract.primary.withOpacity(0.35);
        }
        return FigmaContract.border;
      }),
    ),
  );
}

  ThemeData _buildDarkTheme() {
  final isHighContrast = _appSettingsService.highContrast;

  final bg = isHighContrast
      ? const Color(0xFF0C0B09)
      : const Color(0xFF151311);
  final surface = isHighContrast
      ? const Color(0xFF161411)
      : const Color(0xFF201D19);
  final border = isHighContrast
      ? const Color(0xFF54483D)
      : const Color(0xFF3A342E);
  final textPrimary = isHighContrast
      ? const Color(0xFFFFF8EE)
      : const Color(0xFFF5EDE2);
  final primary = isHighContrast
      ? const Color(0xFFF3C88A)
      : const Color(0xFFE0B06D);
  const danger = Color(0xFFFF8F7B);

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: FigmaContract.fontFamily,
    scaffoldBackgroundColor: bg,
    colorScheme: ColorScheme.dark(
      primary: primary,
      secondary: primary,
      surface: surface,
      error: danger,
      onPrimary: Colors.black,
      onSurface: textPrimary,
    ),
    dividerColor: border,
    cardColor: surface,
    appBarTheme: AppBarTheme(
      backgroundColor: bg,
      foregroundColor: textPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: FigmaContract.body().copyWith(color: textPrimary),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primary;
        }
        return const Color(0xFFF3E9DB);
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primary.withOpacity(0.35);
        }
        return border;
      }),
    ),
    listTileTheme: ListTileThemeData(
      iconColor: textPrimary,
      textColor: textPrimary,
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    if (!_localeLoaded || !_settingsLoaded) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final mediaQuery = MediaQueryData.fromView(
      WidgetsBinding.instance.platformDispatcher.views.first,
    ).copyWith(
      textScaler: TextScaler.linear(_appSettingsService.textScale),
      boldText: _appSettingsService.highContrast,
      disableAnimations: _appSettingsService.reduceMotion,
    );

    return MediaQuery(
      data: mediaQuery,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: _appSettingsService.themeMode,
        theme: _buildLightTheme(),
        darkTheme: _buildDarkTheme(),

        locale: _localeService.locale,
        supportedLocales: const [Locale('fr'), Locale('en')],
        localizationsDelegates: const [
          AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],

        home: _isLoggedIn
            ? Shell(
                onLogout: _logout,
                userName: _userName,
                localeService: _localeService,
                appSettingsService: _appSettingsService,
              )
            : LoginScreen(onLogin: _login),

        onGenerateRoute: (settings) {
          if (settings.name == ScreenMap.details) {
            return MaterialPageRoute(
              builder: (_) => DetailsScreen.demo(),
            );
          }
          return null;
        },
      ),
    );
  }
}