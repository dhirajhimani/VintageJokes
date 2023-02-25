import 'package:flutter/material.dart';
import 'package:vintage_jokes/app/constants/enum.dart';
import 'package:vintage_jokes/app/themes/spacing.dart';
import 'package:vintage_jokes/app/themes/text_styles.dart';
import 'package:vintage_jokes/app/utils/extensions.dart';
import 'package:vintage_jokes/core/presentation/widgets/vintage_jokes_button.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    required this.message,
    this.title,
    this.negativeButtonText,
    this.positiveButtonText,
    this.onNegativePressed,
    this.onPositivePressed,
    this.negativeButtonColor,
    this.positiveButtonColor,
  });
  final String message;
  final String? title;
  final String? negativeButtonText;
  final String? positiveButtonText;
  final VoidCallback? onNegativePressed;
  final VoidCallback? onPositivePressed;
  final Color? negativeButtonColor;
  final Color? positiveButtonColor;

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: title != null
            ? Text(title!, style: AppTextStyle.titleMedium)
            : null,
        content: Padding(
          padding: title != null
              ? EdgeInsets.zero
              : EdgeInsets.only(top: Insets.xxs),
          child: Text(message, style: AppTextStyle.bodyMedium),
        ),
        actions: <Widget>[
          VintageJokesButton(
            text: negativeButtonText ?? context.l10n.common_no.toUpperCase(),
            buttonType: ButtonType.text,
            onPressed: onNegativePressed ?? () => Navigator.of(context).pop(),
            padding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
          ),
          VintageJokesButton(
            text: positiveButtonText ?? context.l10n.common_yes.toUpperCase(),
            buttonType: ButtonType.text,
            onPressed: onPositivePressed ?? () => Navigator.of(context).pop(),
            padding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
          ),
        ],
        actionsPadding: EdgeInsets.symmetric(horizontal: Insets.med),
        buttonPadding: EdgeInsets.zero,
      );
}
