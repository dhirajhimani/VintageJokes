import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:vintage_jokes/app/constants/constant.dart';
import 'package:vintage_jokes/app/constants/enum.dart';
import 'package:vintage_jokes/app/themes/spacing.dart';
import 'package:vintage_jokes/app/utils/dialog_utils.dart';
import 'package:vintage_jokes/app/utils/error_message_utils.dart';
import 'package:vintage_jokes/app/utils/extensions.dart';
import 'package:vintage_jokes/app/utils/injection.dart';
import 'package:vintage_jokes/core/domain/bloc/vintage_jokes/vintage_jokes_bloc.dart';
import 'package:vintage_jokes/core/presentation/widgets/app_title.dart';
import 'package:vintage_jokes/core/presentation/widgets/connectivity_checker.dart';
import 'package:vintage_jokes/core/presentation/widgets/vintage_jokes_button.dart';
import 'package:vintage_jokes/core/presentation/widgets/vintage_jokes_text_field.dart';
import 'package:vintage_jokes/features/auth/domain/bloc/login_bloc.dart';

class LoginScreen extends HookWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController passwordTextController =
        useTextEditingController();
    final TextEditingController emailTextController =
        useTextEditingController();

    return BlocProvider<LoginBloc>(
      create: (BuildContext context) => getIt<LoginBloc>(),
      child: BlocConsumer<LoginBloc, LoginState>(
        builder: (BuildContext context, LoginState state) {
          emailTextController
            ..value = TextEditingValue(text: state.emailAddress ?? '')
            ..selection = TextSelection.fromPosition(
              TextPosition(offset: emailTextController.text.length),
            );

          return ConnectivityChecker.scaffold(
            body: Center(
              child: Container(
                padding: EdgeInsets.all(Insets.xl),
                constraints: const BoxConstraints(
                  maxWidth: Constant.mobileBreakpoint,
                ),
                child: Column(
                  children: <Widget>[
                    const Flexible(child: Center(child: AppTitle())),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          VintageJokesTextField(
                            controller: emailTextController,
                            labelText: context.l10n.login__label_text__email,
                            hintText:
                                context.l10n.login__text_field_hint__email,
                            onChanged: (String value) => context
                                .read<LoginBloc>()
                                .onEmailAddressChanged(value),
                            autofocus: true,
                          ),
                          VSpace.lg,
                          VintageJokesTextField(
                            controller: passwordTextController,
                            labelText: context.l10n.login__label_text__password,
                            hintText:
                                context.l10n.login__text_field_hint__password,
                            textInputType: TextInputType.visiblePassword,
                            isPassword: true,
                          ),
                          VSpace.xxl,
                          VintageJokesButton(
                            text: context.l10n.login__button_text__login,
                            isEnabled: !state.isLoading,
                            isExpanded: true,
                            buttonType: ButtonType.filled,
                            onPressed: () => context.read<LoginBloc>().login(
                                  emailTextController.text,
                                  passwordTextController.text,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        listener: _loginScreenListener,
      ),
    );
  }

  void _loginScreenListener(BuildContext context, LoginState state) {
    if (state.isSuccess) {
      context.read<VintageJokesBloc>().authenticate();
    } else if (state.failure != null) {
      DialogUtils.showToast(
        context,
        ErrorMessageUtils.generate(context, state.failure),
        position: FlashPosition.bottom,
      );
    }
  }
}
