import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_york_times_flutter/cubit/articles_cubit.dart';
import 'package:new_york_times_flutter/models/article_model.dart';
import 'package:new_york_times_flutter/widgets/article_list_item.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NYTimes Top Stories"),
      ),
      body: BlocConsumer<ArticlesCubit, ArticlesState>(
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
