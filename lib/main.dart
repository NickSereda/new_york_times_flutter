import 'package:flutter/material.dart';
import 'package:new_york_times_flutter/app_module.dart';
import 'package:new_york_times_flutter/app_widget.dart';
import 'package:flutter_modular/flutter_modular.dart';

void main() {
  runApp(ModularApp(module: AppModule(), child: AppWidget()));
}

