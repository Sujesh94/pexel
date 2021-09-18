import 'package:http/http.dart' as http;

class HttpMethods {
  Future<http.Response> get(
      String url, Map<String, String> headers) async {
    print(">>>>>>>>get>>   " + url );
    try {
      var uri = Uri.parse(url);
      http.Response response = await http.get(uri, headers: headers);
      return response;
    } catch (err) {
      print("ERROR get -> $err");
      throw err;
    }
  }
}
