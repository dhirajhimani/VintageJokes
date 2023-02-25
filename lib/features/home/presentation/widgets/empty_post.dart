import 'package:flutter/material.dart';
import 'package:vintage_jokes/app/themes/spacing.dart';
import 'package:vintage_jokes/app/themes/text_styles.dart';
import 'package:vintage_jokes/app/utils/extensions.dart';

class EmptyPost extends StatelessWidget {
  const EmptyPost({super.key});

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: Insets.lg),
        color: context.colorScheme.background,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.list_alt,
              size: 200,
              color: context.colorScheme.onBackground.withOpacity(0.25),
            ),
            Padding(
              padding: EdgeInsets.only(top: Insets.sm, bottom: Insets.xs),
              child: Text(
                context.l10n.post__empty_post__empty_post_message,
                style: AppTextStyle.titleLarge.copyWith(
                  color: context.colorScheme.onBackground.withOpacity(0.25),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
}
