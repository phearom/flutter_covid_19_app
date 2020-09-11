import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiHelper {
  static Future<List<dynamic>> getListData(String apiUrl) async {
    try {
      var response = await http.get(apiUrl);
      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List;
        return data;
      } else {
        print('Request failed with status: ${response.statusCode}.');
        return null;
      }
    } catch (e) {
      print("Error API List Data" + e.toString());
      return null;
    }
  }

  static Future<dynamic> getStringData(String apiUrl) async {
    try {
      var response = await http.get(apiUrl);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        print('Request failed with status: ${response.statusCode}.');
        return null;
      }
    } catch (e) {
      print("Error API Single Data" + e.toString());
      return null;
    }
  }
}
