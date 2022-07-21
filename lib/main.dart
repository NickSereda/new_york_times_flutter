import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_york_times_flutter/cubit/articles_cubit.dart';
import 'package:new_york_times_flutter/screens/home_page.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider<ArticlesCubit>(
          create: (context) => ArticlesCubit()..getData(),
          child: MyHomePage()),
    );
  }
}
