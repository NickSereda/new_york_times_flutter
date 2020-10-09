import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:new_york_times_flutter/models/article_model.dart';
import 'package:new_york_times_flutter/services/database_helper.dart';
import 'package:new_york_times_flutter/services/network_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _nyTimesAPIKey = "aLM5wvjyyW0FUDZNmUG0UpSvkvRmf2vm";

  final dbHelper = DatabaseHelper.instance;

  Future<List<ArticleModel>> _articles;

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<List<ArticleModel>> _getData() async {

    //check if database exists and retrieve data from database if so, else download data from NYTimes

    final allRows = await dbHelper.queryAllRows();

    if (allRows.length == 0) {
      print("Rows are empty");

      //fetch from data from nyTimes
      String url =
          "https://api.nytimes.com/svc/topstories/v2/world.json?api-key=$_nyTimesAPIKey";

      NetworkHelper networkHelper = NetworkHelper(url: url);

      dynamic data;

      data = await networkHelper.getData();

      print("downloading articles...");

      print(data);

      int numberOfArticles = data["num_results"];

      print("numberOfArticles : $numberOfArticles");

      List<ArticleModel> articles = [];

      for (var i = 0; i < numberOfArticles; i++) {
        ArticleModel articleModel = ArticleModel(
          title: data["results"][i]["title"].toString(),
          abstract: data["results"][i]["abstract"],
          url: data["results"][i]["url"].toString(),
          multimedia: Multimedia(
            url: data["results"][i]["multimedia"][0]["url"],
            caption: data["results"][i]["multimedia"][0]["caption"],
          ),
          byline: data["results"][i]["byline"].toString(),
        );

        articles.add(articleModel);

        //saving to database
        Map<String, dynamic> row = {
          DatabaseHelper.columnTitle: articleModel.title,
          DatabaseHelper.columnAbstract: articleModel.abstract,
          DatabaseHelper.columnUrl: articleModel.url,
          DatabaseHelper.columnByline: articleModel.byline,
          DatabaseHelper.columnMediaUrl: articleModel.multimedia.url,
          DatabaseHelper.columnMediaCaption: articleModel.multimedia.caption,
        };

        final id = await dbHelper.insert(row);
        print('inserted row id: $id');
      }

      return articles;
    } else {

      print("Rows have data");

      List<ArticleModel> articles = [];

      //download from database
      allRows.forEach((row) {
        articles.add(ArticleModel(
          title: row["title"],
          abstract: row["abstract"],
          byline: row["byline"],
          url: row["url"],
          multimedia: Multimedia(
            url: row["mediaUrl"],
            caption: row["mediaCaption"],
          ),
        ));
        //print(row);
      });
      return articles;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _articles = _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Top Stories"),
      ),
      body: FutureBuilder<List<ArticleModel>>(
          future: _articles,
          builder: (context, AsyncSnapshot<List<ArticleModel>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Text("None");
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Text("Waiting");
              case (ConnectionState.done):
                //   print(snapshot.data);
                return Center(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () async {
                            String url = snapshot.data[index].url;
                            _launchInBrowser(url);
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${snapshot.data[index].title}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900),
                                        ),
                                        Text(
                                          '${snapshot.data[index].abstract}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          '${snapshot.data[index].byline}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ]),
                                ),
                                SizedBox(width: 5),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 100,
                                        width: 120,
                                        child: CachedNetworkImage(
                                          imageUrl: snapshot.data[index].multimedia.url,
                                          imageBuilder: (context, imageProvider) => Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 3,
                                              ),
                                              borderRadius: BorderRadius.circular(10),
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          placeholder: (context, url) => Center(
                                            child: Container(
                                              margin: EdgeInsets.all(25),
                                              child: CircularProgressIndicator(
                                                backgroundColor: Colors.white24,
                                                valueColor: AlwaysStoppedAnimation<Color>(Colors.black26),
                                              ),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) => Icon(Icons.broken_image),
                                        ),

                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        snapshot.data[index].multimedia.caption,
                                        style: TextStyle(fontSize: 8.5),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
//
                          ),
                        );
                      }),
                );
              default:
                return Text("Default");
            }
          }),
    );
  }
}
