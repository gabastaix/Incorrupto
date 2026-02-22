import 'package:flutter/material.dart';
import '../design/figma_contract.dart';
import '../design/screen_map.dart';
import '../screens/details/details_screen.dart';
import 'shell.dart';



class App extends StatelessWidget {
  const App({super.key});

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
    '/': (_) => const Shell(),
    ScreenMap.details: (_) => DetailsScreen.demo(),
  },
);
  }
}