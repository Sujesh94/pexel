import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pexel/core/model/photo_list_model.dart';
import 'package:pexel/core/service/http_methods.dart';
import 'package:pexel/values/api_url.dart';

class PhotoListApi {
  ApiUrl _apiUrl = new ApiUrl();

  HttpMethods _httpMethod = new HttpMethods();


  Future<dynamic> photoList([String? nextPage]) async {
    try {
      if (nextPage == null) {
        nextPage = _apiUrl.photosApi + "?page=1&per_page=40";
      }
      Map<String, String> header = {
        "Authorization":
            "563492ad6f91700001000001a55570f05bc24581b0bb659b1ceafe0d"
      };

      http.Response data = await _httpMethod.get(nextPage, header);
      var jsonData = json.decode(data.body);

      var result = PhotoListModel.fromJson(jsonData);
      return result;
    } catch (err) {
      print('ConfigApi Error: $err');
      return err;
    }
  }
}
