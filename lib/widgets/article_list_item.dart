import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:new_york_times_flutter/models/article_model.dart';
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
        String url = article.url!;
        _launchInBrowser(url);
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
                    Text(
                      '${article.title}',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                    Text(
                      '${article.abstract}',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      '${article.byline}',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ]),
            ),
            SizedBox(width: 5),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Container(
                    height: 100,
                    width: 120,
                    child: CachedNetworkImage(
                      imageUrl: article.multimedia!.url!,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => Center(
                        child: Container(
                          margin: EdgeInsets.all(25),
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white24,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.black26),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.broken_image),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    article.multimedia!.caption!,
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
