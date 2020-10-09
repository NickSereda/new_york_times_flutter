
class ArticleModel {

  Multimedia multimedia;

  String title;
  String abstract;
  String byline;
  String url;


  ArticleModel({

    this.multimedia,

    this.title,
    this.abstract,
    this.byline,
    this.url,
  });


}

class Multimedia {

  String url;
  String caption;

  Multimedia({this.url, this.caption});

}


