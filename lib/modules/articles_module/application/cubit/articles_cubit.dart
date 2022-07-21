import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:new_york_times_flutter/modules/articles_module/infrastructure/repositories/articles_repository_implementation.dart';
import '../../domain/entities/article_model.dart';

part "articles_state.dart";

class ArticlesCubit extends Cubit<ArticlesState> {

  final ArticlesRepositoryImplementation articleRepository;

  ArticlesCubit(this.articleRepository) : super(ArticlesInitial());

  // Getting data, if there is no data - load from nyTimes, otherwise get from database.
  Future<void> getData() async {
    emit(ArticlesLoading());

    try {
      final List<ArticleModel> articles = await articleRepository.getArticles();
      emit(ArticlesLoaded(articles: articles));
    } catch (error) {
      emit(ArticlesError());
    }
  }

}
