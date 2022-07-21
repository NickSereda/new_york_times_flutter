import 'package:flutter_modular/flutter_modular.dart';
import 'package:new_york_times_flutter/modules/articles_module/application/articles_module.dart';

class AppModule extends Module {

  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
    ModuleRoute(Modular.initialRoute, module: ArticlesModule()),
  ];

}