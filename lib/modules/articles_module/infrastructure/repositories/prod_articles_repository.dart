import 'dart:developer';

import 'package:new_york_times_flutter/keys.dart';
import 'package:new_york_times_flutter/modules/articles_module/domain/entities/article_model.dart';
import 'package:new_york_times_flutter/modules/articles_module/domain/entities/articles_result.dart';
import 'package:new_york_times_flutter/modules/articles_module/domain/entities/multimedia.dart';
import 'package:new_york_times_flutter/modules/articles_module/infrastructure/data_sources/i_articles_repository.dart';
import 'package:new_york_times_flutter/modules/articles_module/infrastructure/services/articles_client.dart';
import 'package:new_york_times_flutter/modules/articles_module/infrastructure/services/database_helper.dart';

class ProdArticlesRepository implements IArticlesRepository {
  final DatabaseHelper databaseHelper;

  final ArticlesClient articlesClient;

  ProdArticlesRepository(
    this.databaseHelper,
    this.articlesClient,
  );

  @override
  Future<List<ArticleModel>> getArticles() async {
    //check if database exists and retrieve data from database if so, else download data from NYTimes
    final allRows = await databaseHelper.queryAllRows();

    if (allRows.isEmpty) {
      ArticlesResult result = await articlesClient.getData(nyTimesAPIKey);
      _insertArticlesInDatabase(result.articles);
      return result.articles;
    } else {
      List<ArticleModel> articles = await _getArticlesFromSQLTable(allRows);
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
        DatabaseHelper.columnMediaCaption: article.multimedia.first.caption,
      };
      final id = await databaseHelper.insert(row);
      log('inserted row id: $id');
    }
  }

  Future<List<ArticleModel>> _getArticlesFromSQLTable(List rows) async {
    List<ArticleModel> articles = List.empty(growable: true);
    //download from database
    rows.forEach(
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
