import 'package:flutter/material.dart';
import 'package:vintage_jokes/app/constants/constant.dart';
import 'package:vintage_jokes/app/themes/text_styles.dart';
import 'package:vintage_jokes/app/utils/extensions.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({super.key});

  @override
  Widget build(BuildContext context) => Text(
        Constant.appName,
        style: AppTextStyle.displayLarge
            .copyWith(color: context.colorScheme.primary),
      );
}
