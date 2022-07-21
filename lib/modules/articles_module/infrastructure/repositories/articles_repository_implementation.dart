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

      List<ArticleModel> articles = List.empty(growable: true);

      for (var i = 0; i < result.numResults; i++) {
        ArticleModel articleModel = result.articles[i];

        articles.add(articleModel);

        //saving to database
        Map<String, dynamic> row = {
          DatabaseHelper.columnTitle: articleModel.title,
          DatabaseHelper.columnAbstract: articleModel.abstract,
          DatabaseHelper.columnUrl: articleModel.url,
          DatabaseHelper.columnByline: articleModel.byline,
          DatabaseHelper.columnMediaUrl: articleModel.multimedia.first.url,
          DatabaseHelper.columnMediaCaption:
              articleModel.multimedia.first.caption,
        };

        final id = await databaseHelper.insert(row);
        print('inserted row id: $id');
      }

      return articles;

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
}
