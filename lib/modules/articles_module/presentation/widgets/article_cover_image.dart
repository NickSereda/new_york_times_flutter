import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ArticleItemCoverImage extends StatelessWidget {
  final String? imageUrl;

  const ArticleItemCoverImage({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null)
      return Container(
        height: 100,
        width: 120,
        child: CachedNetworkImage(
          imageUrl: imageUrl!,
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
      );
    else
      return Container();
  }
}
