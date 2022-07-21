
import 'package:new_york_times_flutter/modules/articles_module/domain/entities/multimedia.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'article_model.freezed.dart';
part 'article_model.g.dart';

// Run "flutter pub run build_runner build --delete-conflicting-outputs" to generate code
@freezed
class ArticleModel with _$ArticleModel {
  const factory ArticleModel({
  Multimedia? multimedia,
  String? title,
  String? abstract,
  String? byline,
  String? url,
  }) = _ArticleModel;


  factory ArticleModel.fromJson(Map<String, dynamic> json) => _$ArticleModelFromJson(json);

}

