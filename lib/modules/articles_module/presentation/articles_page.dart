import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:new_york_times_flutter/modules/articles_module/application/cubit/articles_cubit.dart';
import 'package:new_york_times_flutter/modules/articles_module/domain/entities/article_model.dart';
import 'package:new_york_times_flutter/modules/articles_module/presentation/widgets/article_list_item.dart';

class ArticlesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ArticlesCubit _articlesCubit = Modular.get<ArticlesCubit>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Top Stories"),
      ),
      body: BlocConsumer<ArticlesCubit, ArticlesState>(
        bloc: _articlesCubit,
        listenWhen: (prevState, currState) =>
        prevState.status != currState.status,
        listener: (context, state) {
          // Handle errors here
        },
        buildWhen: (prevState, currState) =>
            prevState.status != currState.status,
        builder: (context, state) {
          if (state.status == ArticlesStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == ArticlesStatus.loaded) {
            return Center(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: state.articles.length,
                itemBuilder: (BuildContext context, int index) {
                  final ArticleModel article = state.articles[index];
                  return ArticleListItem(article: article);
                },
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
