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
      body:
      BlocConsumer<ArticlesCubit, ArticlesState>(
        bloc: _articlesCubit,
        listener: (prevState, currState) {},
        builder: (context, state) {
          if (state is ArticlesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ArticlesLoaded) {

            return Center(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: state.articles.length,
                  itemBuilder: (BuildContext context, int index) {
                    final ArticleModel article = state.articles[index];
                    return ArticleListItem(article: article);
                  }),
            );
          }
          return Container();
        },
      ),
    );
  }
}
