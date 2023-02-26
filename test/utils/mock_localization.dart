import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:vintage_jokes/app/generated/l10n.dart';

class MockLocalization extends StatelessWidget {
  const MockLocalization({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Localizations(
        locale: const Locale('en'),
        delegates: const <LocalizationsDelegate<dynamic>>[
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        child: child,
      );
}
