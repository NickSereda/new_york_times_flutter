import 'package:new_york_times_flutter/models/multimedia.dart';

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
