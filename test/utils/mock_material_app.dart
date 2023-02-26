import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:vintage_jokes/app/config/scroll_behavior.dart';
import 'package:vintage_jokes/app/constants/constant.dart';
import 'package:vintage_jokes/app/generated/l10n.dart';
import 'package:vintage_jokes/app/themes/app_theme.dart';

class MockMaterialApp extends StatelessWidget {
  const MockMaterialApp({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: child,
        title: Constant.appName,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.delegate.supportedLocales,
        debugShowCheckedModeBanner: false,
        scrollBehavior: ScrollBehaviorConfig(),
      );
}
