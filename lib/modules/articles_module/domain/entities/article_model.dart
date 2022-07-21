
import 'package:new_york_times_flutter/modules/articles_module/domain/entities/multimedia.dart';

class ArticleModel {
  Multimedia? multimedia;

  String? title;
  String? abstract;
  String? byline;
  String? url;

  ArticleModel({
    this.multimedia,
    this.title,
    this.abstract,
    this.byline,
    this.url,
  });
}
