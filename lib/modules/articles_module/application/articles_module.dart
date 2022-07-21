import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:new_york_times_flutter/modules/articles_module/application/cubit/articles_cubit.dart';
import 'package:new_york_times_flutter/modules/articles_module/infrastructure/repositories/articles_repository_implementation.dart';
import 'package:new_york_times_flutter/modules/articles_module/infrastructure/services/network_helper.dart';
import 'package:new_york_times_flutter/modules/articles_module/presentation/articles_page.dart';

import '../infrastructure/services/database_helper.dart';

class ArticlesModule extends Module {

  @override
  List<Bind> get binds => [
    Bind((i) => Dio((BaseOptions(contentType: "application/json")))),
    Bind((i) => DatabaseHelper.instance),
    Bind((i) => NetworkHelper(i())),
    Bind((i) => ArticlesRepositoryImplementation(i(),i())),
    Bind((i) => ArticlesCubit(i())..getData()),
  ];

  @override
  List<ModularRoute> get routes => [
    ChildRoute(Modular.initialRoute, child: (context, args) => ArticlesPage()),
  ];

}