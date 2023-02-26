import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:vintage_jokes/app/config/scroll_behavior.dart';
import 'package:vintage_jokes/app/constants/constant.dart';
import 'package:vintage_jokes/app/generated/l10n.dart';
import 'package:vintage_jokes/app/routes/app_router.dart';
import 'package:vintage_jokes/app/themes/app_theme.dart';
import 'package:vintage_jokes/app/utils/injection.dart';
import 'package:vintage_jokes/core/domain/bloc/vintage_jokes/vintage_jokes_bloc.dart';

class App extends StatelessWidget {
  App({super.key});

  final GoRouter routerConfig =
      getIt<AppRouter>(param1: getIt<VintageJokesBloc>()).router;

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: <BlocProvider<dynamic>>[
          BlocProvider<VintageJokesBloc>(
            create: (BuildContext context) => getIt<VintageJokesBloc>(),
          ),
        ],
        child: BlocBuilder<VintageJokesBloc, VintageJokesState>(
          builder: (BuildContext context, VintageJokesState state) =>
              MaterialApp.router(
            routerConfig: routerConfig,
            builder: (BuildContext context, Widget? widget) =>
                ResponsiveWrapper.builder(
              widget,
              minWidth: Constant.mobileBreakpoint,
              breakpoints: const <ResponsiveBreakpoint>[
                ResponsiveBreakpoint.autoScaleDown(
                  Constant.mobileBreakpoint,
                  name: PHONE,
                ),
                ResponsiveBreakpoint.resize(
                  Constant.mobileBreakpoint,
                  name: MOBILE,
                ),
                ResponsiveBreakpoint.resize(
                  Constant.tabletBreakpoint,
                  name: TABLET,
                ),
                ResponsiveBreakpoint.resize(
                  Constant.desktopBreakpoint,
                  name: DESKTOP,
                ),
              ],
            ),
            title: Constant.appName,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.themeMode,
            localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.delegate.supportedLocales,
            debugShowCheckedModeBanner: false,
            scrollBehavior: ScrollBehaviorConfig(),
          ),
        ),
      );
}
