import 'package:flutter_modular/flutter_modular.dart';
import 'package:new_york_times_flutter/modules/articles_module/application/cubit/articles_cubit.dart';
import 'package:new_york_times_flutter/modules/articles_module/presentation/articles_page.dart';

class AppModule extends Module {

  @override
  List<Bind> get binds => [
    Bind((i) => ArticlesCubit()..getData()),
  ];

  @override
  List<ModularRoute> get routes => [
    ChildRoute(Modular.initialRoute, child: (context, args) => ArticlesPage()),
  ];

}