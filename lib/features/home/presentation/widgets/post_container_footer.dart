import 'package:flutter/material.dart';
import 'package:vintage_jokes/app/themes/app_theme.dart';
import 'package:vintage_jokes/app/themes/spacing.dart';
import 'package:vintage_jokes/app/themes/text_styles.dart';
import 'package:vintage_jokes/app/utils/extensions.dart';
import 'package:vintage_jokes/features/home/domain/model/post.dart';

class PostContainerFooter extends StatelessWidget {
  const PostContainerFooter({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) => Row(
        children: <Widget>[
          _FooterItems(
            leftIcon: Icons.arrow_upward_rounded,
            value: post.upvotes.getOrCrash() == 0
                ? context.l10n.post__upvotes_default_value__vote
                : post.upvotes.getOrCrash().toString(),
            rightIcon: Icons.arrow_downward_rounded,
          ),
          _FooterItems(
            leftIcon: Icons.chat_bubble_outline,
            value: post.comments.getOrCrash().toString(),
          ),
        ],
      );
}

class _FooterItems extends StatelessWidget {
  const _FooterItems({
    required this.leftIcon,
    required this.value,
    this.rightIcon,
  });

  final IconData leftIcon;
  final IconData? rightIcon;

  final String value;

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: Insets.xs),
        decoration: BoxDecoration(
          border: Border.all(
            color: context.colorScheme.onBackground.withOpacity(0.25),
          ),
          borderRadius: AppTheme.defaultBoardRadius,
        ),
        margin: EdgeInsets.symmetric(horizontal: Insets.xxs),
        child: Row(
          children: <Widget>[
            Icon(
              leftIcon,
              size: (AppTextStyle.bodySmall.fontSize ?? 14) * 1.5,
              color: context.colorScheme.secondary,
            ),
            Padding(
              padding: EdgeInsets.all(Insets.xs),
              child: Text(
                value,
                style: AppTextStyle.bodySmall.copyWith(
                  color: context.colorScheme.secondary,
                ),
              ),
            ),
            if (rightIcon != null)
              Icon(
                rightIcon,
                size: (AppTextStyle.bodySmall.fontSize ?? 14) * 1.5,
                color: context.colorScheme.secondary,
              ),
          ],
        ),
      );
}
