import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vintage_jokes/app/constants/constant.dart';
import 'package:vintage_jokes/app/constants/route.dart';
import 'package:vintage_jokes/app/themes/spacing.dart';
import 'package:vintage_jokes/app/utils/dialog_utils.dart';
import 'package:vintage_jokes/app/utils/error_message_utils.dart';
import 'package:vintage_jokes/app/utils/injection.dart';
import 'package:vintage_jokes/core/domain/bloc/vintage_jokes/vintage_jokes_bloc.dart';
import 'package:vintage_jokes/core/presentation/screens/error_screen.dart';
import 'package:vintage_jokes/core/presentation/screens/loading_screen.dart';
import 'package:vintage_jokes/core/presentation/widgets/connectivity_checker.dart';
import 'package:vintage_jokes/core/presentation/widgets/vintage_jokes_app_bar.dart';
import 'package:vintage_jokes/core/presentation/widgets/vintage_jokes_avatar.dart';
import 'package:vintage_jokes/core/presentation/widgets/vintage_jokes_nav_bar.dart';
import 'package:vintage_jokes/features/home/domain/bloc/post/post_bloc.dart';

class VintageJokesScreen extends StatelessWidget {
  const VintageJokesScreen({
    super.key,
    required this.child,
  });

  final Widget child;
  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () => DialogUtils.showExitDialog(context),
        child: MultiBlocProvider(
          providers: <BlocProvider<dynamic>>[
            BlocProvider<PostBloc>(
              create: (BuildContext context) => getIt<PostBloc>(),
            ),
          ],
          child: BlocBuilder<VintageJokesBloc, VintageJokesState>(
            builder: (BuildContext context, VintageJokesState state) {
              if (state.failure != null) {
                return ErrorScreen(
                  onRefresh: () =>
                      context.read<VintageJokesBloc>().initialize(),
                  errorMessage:
                      ErrorMessageUtils.generate(context, state.failure),
                );
              } else if (state.user != null) {
                return ConnectivityChecker(
                  child: Scaffold(
                    appBar: PreferredSize(
                      preferredSize:
                          Size.fromHeight(AppBar().preferredSize.height),
                      child: VintageJokesAppBar(
                        actions: <Widget>[
                          IconButton(
                            onPressed: () => context
                                .read<VintageJokesBloc>()
                                .switchTheme(Theme.of(context).brightness),
                            icon:
                                Theme.of(context).brightness == Brightness.dark
                                    ? const Icon(Icons.light_mode)
                                    : const Icon(Icons.dark_mode),
                          ),
                          GestureDetector(
                            onTap: () => GoRouter.of(context)
                                .goNamed(RouteName.profile.name),
                            child: VintageJokesAvatar(
                              size: 32,
                              imageUrl: state.user!.avatar?.getOrCrash(),
                              padding: EdgeInsets.all(Insets.sm),
                            ),
                          ),
                        ],
                        leading: GoRouter.of(context)
                                .location
                                .contains('/home/')
                            ? BackButton(
                                onPressed: () => GoRouter.of(context).canPop()
                                    ? GoRouter.of(context).pop()
                                    : null,
                              )
                            : null,
                      ),
                    ),
                    body: SafeArea(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: Constant.mobileBreakpoint,
                          ),
                          child: child,
                        ),
                      ),
                    ),
                    bottomNavigationBar: const VintageJokesNavBar(),
                  ),
                );
              } else {
                return LoadingScreen.scaffold();
              }
            },
          ),
        ),
      );
}
