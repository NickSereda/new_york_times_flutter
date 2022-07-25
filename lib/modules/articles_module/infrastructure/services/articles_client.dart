import 'package:new_york_times_flutter/modules/articles_module/domain/entities/articles_result.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'articles_client.g.dart';

@RestApi(baseUrl: "https://api.nytimes.com/")
abstract class ArticlesClient {

  factory ArticlesClient(Dio dio, {String baseUrl}) = _ArticlesClient;

  @GET("svc/topstories/v2/world.json?api-key={apiKey}")
  Future<ArticlesResult> getData(@Path("apiKey") String apiKey);
}


