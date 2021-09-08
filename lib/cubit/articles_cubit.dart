import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:new_york_times_flutter/keys.dart';
import 'package:new_york_times_flutter/models/article_model.dart';
import 'package:new_york_times_flutter/models/multimedia.dart';
import 'package:new_york_times_flutter/services/database_helper.dart';
import 'package:new_york_times_flutter/services/network_helper.dart';

part "articles_state.dart";

class ArticlesCubit extends Cubit<ArticlesState> {
  ArticlesCubit() : super(ArticlesInitial());

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Getting data, if there is no data - load from nyTimes, otherwise get from database.
  Future<void> getData() async {
    emit(ArticlesLoading());

    try {
      //check if database exists and retrieve data from database if so, else download data from NYTimes
      final allRows = await _dbHelper.queryAllRows();

      if (allRows.length == 0) {
        print("Rows are empty");
        //fetch from data from nyTimes
        String url =
            "https://api.nytimes.com/svc/topstories/v2/world.json?api-key=$nyTimesAPIKey";

        final NetworkHelper networkHelper = NetworkHelper(url: url);

        dynamic data;

        data = await networkHelper.getData();

        print("downloading articles...");

        final int numberOfArticles = data["num_results"];

        List<ArticleModel> articles = [];

        for (var i = 0; i < numberOfArticles; i++) {
          ArticleModel articleModel = ArticleModel(
            title: data["results"][i]["title"].toString(),
            abstract: data["results"][i]["abstract"],
            url: data["results"][i]["url"].toString(),
            multimedia: Multimedia(
              url: data["results"][i]["multimedia"][0]["url"],
              caption: data["results"][i]["multimedia"][0]["caption"],
            ),
            byline: data["results"][i]["byline"].toString(),
          );

          articles.add(articleModel);

          //saving to database
          Map<String, dynamic> row = {
            DatabaseHelper.columnTitle: articleModel.title,
            DatabaseHelper.columnAbstract: articleModel.abstract,
            DatabaseHelper.columnUrl: articleModel.url,
            DatabaseHelper.columnByline: articleModel.byline,
            DatabaseHelper.columnMediaUrl: articleModel.multimedia.url,
            DatabaseHelper.columnMediaCaption: articleModel.multimedia.caption,
          };

          final id = await _dbHelper.insert(row);
          print('inserted row id: $id');
        }

        emit(ArticlesLoaded(articles: articles));
      } else {
        print("Rows have data");

        List<ArticleModel> articles = [];

        //download from database
        allRows.forEach((row) {
          articles.add(ArticleModel(
            title: row["title"],
            abstract: row["abstract"],
            byline: row["byline"],
            url: row["url"],
            multimedia: Multimedia(
              url: row["mediaUrl"],
              caption: row["mediaCaption"],
            ),
          ));
        });

        emit(ArticlesLoaded(articles: articles));

        return articles;
      }
    } catch (error) {
      emit(ArticlesError());
    }
  }

}
