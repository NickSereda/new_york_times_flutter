import 'package:bloc_test/bloc_test.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:new_york_times_flutter/modules/articles_module/application/cubit/articles_cubit.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:new_york_times_flutter/modules/articles_module/domain/entities/article_model.dart';
import 'package:new_york_times_flutter/modules/articles_module/infrastructure/data_sources/articles_repository.dart';

import 'articles_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ArticlesRepository>()])
final _fakeArticles = [
  ArticleModel(
    title: 'article 1',
    abstract: 'abstract 1',
  ),
  ArticleModel(
    title: 'article 2',
    abstract: 'abstract 2',
  ),
  ArticleModel(
    title: 'article 3',
    abstract: 'abstract 3',
  ),
];

void main() {
  late ArticlesCubit articlesCubit;
  late MockArticlesRepository repository;

  setUp(() {
    repository = MockArticlesRepository();

    when(repository.getArticles()).thenAnswer((_) async => _fakeArticles);

    articlesCubit = ArticlesCubit(repository);
  });

  group('TodosCubit test', () {
    test('TodosCubit initial state test', () {
      expect(
        articlesCubit.state,
        const ArticlesState(articles: [], status: ArticlesStatus.initial),
      );
    });

    blocTest<ArticlesCubit, ArticlesState>(
      'TodosCubit emits loading state and loaded state wiht todo '
      'when addTodo() is called',
      build: () => articlesCubit,
      act: (bloc) async {
        await bloc.getData();
      },
      expect: () => [
        const ArticlesState(
          status: ArticlesStatus.loading,
          articles: [],
        ),
        ArticlesState(
          status: ArticlesStatus.loaded,
          articles: _fakeArticles,
        ),
      ],
    );
  });
}
