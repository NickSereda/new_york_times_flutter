import 'package:new_york_times_flutter/modules/articles_module/domain/entities/multimedia.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'article_model.freezed.dart';

part 'article_model.g.dart';

// Run "flutter pub run build_runner build --delete-conflicting-outputs" to generate code
@freezed
class ArticleModel with _$ArticleModel {
  const factory ArticleModel({
    @JsonKey(name: "multimedia")
    @Default(<Multimedia>[])
        List<Multimedia> multimedia,
    @JsonKey(name: "title") String? title,
    @JsonKey(name: "abstract") String? abstract,
    @JsonKey(name: "byline") String? byline,
    @JsonKey(name: "url") String? url,
  }) = _ArticleModel;

  factory ArticleModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleModelFromJson(json);
}
