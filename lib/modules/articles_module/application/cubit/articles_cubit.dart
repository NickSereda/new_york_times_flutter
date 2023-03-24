import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:new_york_times_flutter/modules/articles_module/domain/entities/article_model.dart';
import 'package:new_york_times_flutter/modules/articles_module/infrastructure/data_sources/articles_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'articles_cubit.freezed.dart';

part "articles_state.dart";

class ArticlesCubit extends Cubit<ArticlesState> {
  final ArticlesRepository articleRepository;

  ArticlesCubit(this.articleRepository)
      : super(ArticlesState(articles: [], status: ArticlesStatus.initial));

  // Getting data, if there is no data - load from nyTimes, otherwise get from database.
  Future<void> getData() async {
    emit(state.copyWith(status: ArticlesStatus.loading));
    try {
      final List<ArticleModel> articles = await articleRepository.getArticles();
      emit(state.copyWith(status: ArticlesStatus.loaded, articles: articles));
    } catch (error) {
      emit(state.copyWith(status: ArticlesStatus.error));
    }
  }
}
