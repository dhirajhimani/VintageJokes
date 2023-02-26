import 'package:flutter/material.dart';
import 'package:vintage_jokes/app/themes/spacing.dart';
import 'package:vintage_jokes/app/themes/text_styles.dart';
import 'package:vintage_jokes/core/domain/model/value_objects.dart';

class VintageJokesTextUrl extends StatelessWidget {
  const VintageJokesTextUrl({
    super.key,
    required this.url,
    required this.onTap,
    this.style,
    this.isShowIcon = true,
  });

  final Url url;
  final TextStyle? style;
  final bool isShowIcon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Row(
          children: <Widget>[
            Flexible(
              child: Text(
                url.getOrCrash(),
                style: style?.copyWith(decoration: TextDecoration.underline) ??
                    AppTextStyle.bodySmall.copyWith(
                      color: Colors.lightBlue,
                      decoration: TextDecoration.underline,
                    ),
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textWidthBasis: TextWidthBasis.longestLine,
              ),
            ),
            if (isShowIcon)
              Padding(
                padding: EdgeInsets.only(left: Insets.xxs),
                child: Icon(
                  Icons.open_in_new,
                  size: style?.fontSize ?? AppTextStyle.bodySmall.fontSize,
                  color: Colors.lightBlue,
                ),
              ),
          ],
        ),
      );
}
