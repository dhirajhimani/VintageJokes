import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:vintage_jokes/app/constants/enum.dart';
import 'package:vintage_jokes/app/themes/spacing.dart';
import 'package:vintage_jokes/app/themes/text_styles.dart';
import 'package:vintage_jokes/app/utils/error_message_utils.dart';
import 'package:vintage_jokes/app/utils/extensions.dart';
import 'package:vintage_jokes/app/utils/hooks.dart';
import 'package:vintage_jokes/core/domain/bloc/vintage_jokes/vintage_jokes_bloc.dart';
import 'package:vintage_jokes/core/domain/model/user.dart';
import 'package:vintage_jokes/core/presentation/screens/error_screen.dart';
import 'package:vintage_jokes/core/presentation/screens/loading_screen.dart';
import 'package:vintage_jokes/core/presentation/widgets/vintage_jokes_avatar.dart';
import 'package:vintage_jokes/core/presentation/widgets/vintage_jokes_button.dart';
import 'package:vintage_jokes/core/presentation/widgets/vintage_jokes_info_text_field.dart';

class ProfileScreen extends HookWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RefreshController refreshController = useRefreshController();

    return BlocBuilder<VintageJokesBloc, VintageJokesState>(
      builder: (BuildContext context, VintageJokesState state) {
        final User user = state.user!;
        final bool hasContactNumber =
            user.contactNumber?.getOrCrash().isNotNullOrBlank ?? false;
        if (state.isLoading) {
          return const LoadingScreen();
        } else if (state.failure != null) {
          return ErrorScreen(
            onRefresh: () => context.read<VintageJokesBloc>().getUser(),
            errorMessage: ErrorMessageUtils.generate(context, state.failure),
          );
        }

        return SmartRefresher(
          controller: refreshController,
          header: const ClassicHeader(),
          onRefresh: () => context.read<VintageJokesBloc>().getUser(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Insets.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                VSpace(Insets.lg),
                Row(
                  children: <Widget>[
                    VintageJokesAvatar(
                      size: 80,
                      imageUrl: user.avatar?.getOrCrash(),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(Insets.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              user.firstName.getOrCrash(),
                              style: AppTextStyle.headlineMedium,
                            ),
                            Text(
                              user.lastName.getOrCrash(),
                              style: AppTextStyle.headlineMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                VSpace(Insets.med),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      VSpace.sm,
                      VintageJokesInfoTextField(
                        title: context.l10n.profile__label_text__email,
                        description: user.email.getOrCrash(),
                      ),
                      if (hasContactNumber) VSpace.sm,
                      if (hasContactNumber)
                        VintageJokesInfoTextField(
                          title: context.l10n.profile__label_text__phone_number,
                          description: user.contactNumber!.getOrCrash(),
                        ),
                      VSpace.sm,
                      VintageJokesInfoTextField(
                        title: context.l10n.profile__label_text__gender,
                        description: user.gender.name.capitalize(),
                      ),
                      VSpace.sm,
                      VintageJokesInfoTextField(
                        title: context.l10n.profile__label_text__birthday,
                        description: user.birthday.defaultFormat(),
                      ),
                      VSpace.sm,
                      VintageJokesInfoTextField(
                        title: context.l10n.profile__label_text__age,
                        description: user.age,
                      ),
                    ],
                  ),
                ),
                Center(
                  child: VintageJokesButton(
                    text: context.l10n.profile__button_text__logout,
                    isExpanded: true,
                    buttonType: ButtonType.filled,
                    onPressed: () => context.read<VintageJokesBloc>().logout(),
                    padding: EdgeInsets.zero,
                    contentPadding: EdgeInsets.symmetric(vertical: Insets.med),
                  ),
                ),
                VSpace(Insets.lg),
              ],
            ),
          ),
        );
      },
    );
  }
}
