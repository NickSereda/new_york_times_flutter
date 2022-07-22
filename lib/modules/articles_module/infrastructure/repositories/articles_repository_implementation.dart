import 'dart:developer';

import 'package:new_york_times_flutter/modules/articles_module/domain/entities/article_model.dart';
import 'package:new_york_times_flutter/modules/articles_module/domain/entities/articles_result.dart';
import 'package:new_york_times_flutter/modules/articles_module/domain/entities/multimedia.dart';
import 'package:new_york_times_flutter/modules/articles_module/infrastructure/data_sources/articles_repository.dart';
import 'package:new_york_times_flutter/modules/articles_module/infrastructure/services/database_helper.dart';
import 'package:new_york_times_flutter/modules/articles_module/infrastructure/services/network_helper.dart';

class ArticlesRepositoryImplementation implements ArticlesRepository {
  final DatabaseHelper databaseHelper;

  final NetworkHelper networkHelper;

  ArticlesRepositoryImplementation(this.databaseHelper, this.networkHelper);

  @override
  Future<List<ArticleModel>> getArticles() async {
    //check if database exists and retrieve data from database if so, else download data from NYTimes
    final allRows = await databaseHelper.queryAllRows();

    if (allRows.isEmpty) {
      log("Rows are empty");

      ArticlesResult result = await networkHelper.getData();

      _insertArticlesInDatabase(result.articles);

      return result.articles;

    } else {
      log("Rows have data");

      List<ArticleModel> articles = List.empty(growable: true);

      //download from database
      allRows.forEach(
        (row) {
          articles.add(
            ArticleModel(
              title: row["title"],
              abstract: row["abstract"],
              byline: row["byline"],
              url: row["url"],
              multimedia: [
                Multimedia(
                  url: row["mediaUrl"],
                  caption: row["mediaCaption"],
                ),
              ],
            ),
          );
        },
      );
      return articles;
    }
  }

  Future<void> _insertArticlesInDatabase(List<ArticleModel> articles) async {
    for (ArticleModel article in articles) {
      //saving to database
      Map<String, dynamic> row = {
        DatabaseHelper.columnTitle: article.title,
        DatabaseHelper.columnAbstract: article.abstract,
        DatabaseHelper.columnUrl: article.url,
        DatabaseHelper.columnByline: article.byline,
        DatabaseHelper.columnMediaUrl: article.multimedia.first.url,
        DatabaseHelper.columnMediaCaption:
        article.multimedia.first.caption,
      };
      final id = await databaseHelper.insert(row);
      log('inserted row id: $id');
    }
  }

}
