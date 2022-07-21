part of 'articles_cubit.dart';

enum ArticlesStatus {
  initial,
  loading,
  loaded,
  error,
}

class ArticlesState extends Equatable {
  final List<ArticleModel> articles;
  final ArticlesStatus status;

  const ArticlesState({
    required this.articles,
    required this.status,
  });

  @override
  List<Object> get props => [articles, status];

  ArticlesState copyWith({
    List<ArticleModel>? articles,
    ArticlesStatus? status,
  }) {
    return ArticlesState(
      articles: articles ?? this.articles,
      status: status ?? this.status,
    );
  }
}
