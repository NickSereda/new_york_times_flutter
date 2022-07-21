import 'package:http/http.dart' as http;
import 'dart:convert';



class NetworkHelper {

  NetworkHelper({this.url});

  final String? url;

  Future getData() async {

    http.Response responce;

    responce = await http.get(Uri.parse(url!));

    //if success
    if (responce.statusCode == 200) {

//      String data = responce.body;
//      return jsonDecode(data);

      //for String Decoding
      return jsonDecode(utf8.decode(responce.bodyBytes));

    }
  }
}