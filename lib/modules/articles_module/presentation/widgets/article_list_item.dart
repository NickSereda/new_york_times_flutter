import 'package:flutter/material.dart';
import 'package:new_york_times_flutter/modules/articles_module/domain/entities/article_model.dart';
import 'package:new_york_times_flutter/modules/articles_module/presentation/widgets/article_cover_image.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleListItem extends StatelessWidget {
  final ArticleModel article;

  const ArticleListItem({required this.article});

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final String? url = article.url;
        if (url != null) {
          _launchInBrowser(url);
        }
      },
      child: Container(
        padding: EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (article.title != null)
                    Text(
                      article.title!,
                      style: Theme.of(context).textTheme.caption,
                    ),
                    if (article.abstract != null)
                    Text(
                      article.abstract!,
                      style: Theme.of(context).textTheme.caption,
                    ),
                    if (article.byline != null)
                    Text(
                      article.byline!,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ]),
            ),
            SizedBox(width: 5),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  ArticleItemCoverImage(imageUrl: article.multimedia.first.url!),
                  SizedBox(height: 5),
                  if (article.multimedia.first.caption != null)
                    Text(
                      article.multimedia.first.caption!,
                      style: TextStyle(fontSize: 8.5),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
