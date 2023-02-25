import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vintage_jokes/app/utils/extensions.dart';

class VintageJokesAvatar extends StatelessWidget {
  const VintageJokesAvatar({
    super.key,
    required this.size,
    this.imageUrl,
    this.padding,
  });

  final String? imageUrl;
  final double size;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) => Semantics(
        image: true,
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: imageUrl != null
              ? CachedNetworkImage(
                  imageUrl: imageUrl!,
                  imageBuilder: (
                    BuildContext context,
                    ImageProvider<Object> imageProvider,
                  ) =>
                      Container(
                    decoration: BoxDecoration(
                      color: context.colorScheme.onBackground,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                      shape: BoxShape.circle,
                    ),
                    width: size,
                    height: size,
                  ),
                  errorWidget:
                      (BuildContext context, String url, dynamic error) =>
                          Icon(Icons.account_circle, size: size),
                  fit: BoxFit.cover,
                )
              : Icon(Icons.account_circle, size: size),
        ),
      );
}
