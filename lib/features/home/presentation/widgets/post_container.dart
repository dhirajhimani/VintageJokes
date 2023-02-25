import 'package:dartx/dartx.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vintage_jokes/app/constants/route.dart';
import 'package:vintage_jokes/app/themes/spacing.dart';
import 'package:vintage_jokes/app/themes/text_styles.dart';
import 'package:vintage_jokes/core/presentation/widgets/vintage_jokes_text_url.dart';
import 'package:vintage_jokes/features/home/domain/model/post.dart';
import 'package:vintage_jokes/features/home/presentation/widgets/post_container_footer.dart';
import 'package:vintage_jokes/features/home/presentation/widgets/post_container_header.dart';

class PostContainer extends StatelessWidget {
  const PostContainer({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: Insets.sm),
        child: GestureDetector(
          onTap: () => launchPostDetails(context),
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(Insets.xs),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  PostContainerHeader(post: post),
                  if (post.urlOverriddenByDest != null)
                    Padding(
                      padding: EdgeInsets.all(Insets.med),
                      child: VintageJokesTextUrl(
                        url: post.urlOverriddenByDest!,
                        onTap: () => launchUrl(
                          Uri.parse(
                            post.urlOverriddenByDest!.getOrCrash(),
                          ),
                        ),
                      ),
                    ),
                  if (post.selftext.getOrCrash().isNotNullOrBlank)
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.only(bottom: Insets.xs),
                        foregroundDecoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors:
                                Theme.of(context).brightness == Brightness.light
                                    ? <Color>[
                                        const Color(0xFFf0f4fa),
                                        const Color(0xFFf0f4fa).withOpacity(0),
                                      ]
                                    : <Color>[
                                        const Color(0xFF202429),
                                        const Color(0xFF202429).withOpacity(0),
                                      ],
                          ),
                        ),
                        constraints: const BoxConstraints(maxHeight: 200),
                        child: IgnorePointer(
                          child: Markdown(
                            data: post.selftext.getOrCrash(),
                            styleSheet:
                                MarkdownStyleSheet(p: AppTextStyle.bodyMedium),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                          ),
                        ),
                      ),
                    ),
                  PostContainerFooter(post: post),
                ],
              ),
            ),
          ),
        ),
      );

  Future<void> launchPostDetails(BuildContext context) async {
    if (kIsWeb) {
      await launchUrl(
        Uri.parse(post.permalink.getOrCrash()),
        webOnlyWindowName: '_blank',
      );
    } else {
      GoRouter.of(context).pushNamed(
        RouteName.postDetails.name,
        params: <String, String>{'postId': post.uid.getOrCrash()},
        extra: post,
      );
    }
  }
}
