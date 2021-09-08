part of 'articles_cubit.dart';

abstract class ArticlesState extends Equatable {
  const ArticlesState();

  @override
  List<Object> get props => [];
}

class ArticlesInitial extends ArticlesState {
  const ArticlesInitial();
}

class ArticlesLoading extends ArticlesState {
  const ArticlesLoading();
}

class ArticlesLoaded extends ArticlesState {
  final List<ArticleModel> articles;

  const ArticlesLoaded({@required this.articles});

  @override
  List<Object> get props => [articles];
}

class ArticlesError extends ArticlesState {
  const ArticlesError();
}
