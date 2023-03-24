import 'package:new_york_times_flutter/modules/articles_module/domain/entities/article_model.dart';

abstract class IArticlesRepository {
  Future<List<ArticleModel>> getArticles();
}
