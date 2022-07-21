

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:new_york_times_flutter/modules/articles_module/domain/entities/article_model.dart';


part 'articles_result.freezed.dart';

part 'articles_result.g.dart';

@freezed
class ArticlesResult with _$ArticlesResult {

  const factory ArticlesResult({
  @JsonKey(name: "num_results") required int numResults,
    @JsonKey(name: "results") required List<ArticleModel> articles,
  }) = _ArticlesResult;

  factory ArticlesResult.fromJson(Map<String, dynamic> json) => _$ArticlesResultFromJson(json);
}