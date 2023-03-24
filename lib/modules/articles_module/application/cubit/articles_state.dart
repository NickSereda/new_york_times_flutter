part of 'articles_cubit.dart';

enum ArticlesStatus {
  initial,
  loading,
  loaded,
  error,
}

@freezed
class ArticlesState with _$ArticlesState {
  const factory ArticlesState({
    @Default(<ArticleModel>[]) List<ArticleModel> articles,
    required ArticlesStatus status,
  }) = _ArticlesState;
}
