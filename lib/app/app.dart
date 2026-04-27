import 'package:flutter/material.dart';
import '../design/figma_contract.dart';
import '../design/screen_map.dart';
import '../screens/details/details_screen.dart';
import '../screens/login/login_screen.dart';
import 'shell.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool _isLoggedIn = false;
  String _userName = '';

  void _login(String email) {
    setState(() {
      _isLoggedIn = true;
      _userName = _deriveUserName(email);
    });
  }

  void _logout() {
    setState(() {
      _isLoggedIn = false;
      _userName = '';
    });
  }

  String _deriveUserName(String email) {
    final localPart = email.split('@').first;
    final cleaned = localPart.replaceAll(RegExp(r'[._\-]+'), ' ').trim();
    if (cleaned.isEmpty) return '';
    final firstWord = cleaned.split(' ').first;
    return firstWord[0].toUpperCase() + firstWord.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: FigmaContract.bg,
      fontFamily: FigmaContract.fontFamily == 'TODO_FONT'
          ? null
          : FigmaContract.fontFamily,
      appBarTheme: AppBarTheme(
        backgroundColor: FigmaContract.bg,
        foregroundColor: FigmaContract.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: FigmaContract.body(),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      initialRoute: '/',
      routes: {
        '/': (_) => _isLoggedIn ? Shell(onLogout: _logout, userName: _userName) : LoginScreen(onLogin: _login),
        ScreenMap.details: (_) => DetailsScreen.demo(),
      },
    );
  }
}