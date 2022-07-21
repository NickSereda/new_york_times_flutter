import 'package:new_york_times_flutter/keys.dart';
import 'package:new_york_times_flutter/modules/articles_module/domain/entities/articles_result.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'network_helper.g.dart';

@RestApi(baseUrl: "https://api.nytimes.com/")
abstract class NetworkHelper {

  factory NetworkHelper(Dio dio, {String baseUrl}) = _NetworkHelper;

  @GET("svc/topstories/v2/world.json?api-key=$nyTimesAPIKey")
  Future<ArticlesResult> getData();
}


