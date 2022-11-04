import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class RequestSender{
  final String domain = "Torium-api.eba-svaq5mu4.eu-central-1.elasticbeanstalk.com";

  Future<Map> get(String path, { Map<String, String> requestHeaders = const {}}) async {
      try {
        var url = Uri.http(domain, path);

        var response = await http.get(url, headers: requestHeaders);
        if (response.statusCode == 200) {
          return convert.jsonDecode(response.body) as Map<String, dynamic>;
        }
      }
      catch(error) {
        print(error);
        return {};
      }
      return {};
    }

  Future<Map> post(String path, Map<String, String> requestHeaders, Map<String, String> body) async {
    try {
      var url = Uri.http(domain, path);
      var bodyParsed = json.encode(body);
      var headers = addApplicationType(requestHeaders);

      var response = await http.post(
          url,
          headers: headers,
          body: bodyParsed
      );
      if (response.statusCode == 200) {
        return convert.jsonDecode(response.body) as Map<String, dynamic>;
      }
    }
    catch(error) {
      print(error);
      return {};
    }
    return {};
  }

  Future<Map> patch(String path, Map<String, String> requestHeaders, Map<String, String> body) async {
    try {
      var url = Uri.http(domain, path);
      var bodyParsed = json.encode(body);
      var headers = addApplicationType(requestHeaders);

      var response = await http.patch(
          url,
          headers: headers,
          body: bodyParsed
      );
      if (response.statusCode == 200) {
        return convert.jsonDecode(response.body) as Map<String, dynamic>;
      }
    }
    catch(error) {
      print(error);
      return {};
    }
    return {};
  }

  Future<Map> delete(String path, Map<String, String> requestHeaders, Map<dynamic, dynamic> body) async {
    try {
      var url = Uri.http(domain, path);
      var bodyParsed = json.encode(body);
      var headers = addApplicationType(requestHeaders);

      var response = await http.delete(
          url,
          headers: headers,
          body: bodyParsed
      );
      if (response.statusCode == 200) {
        return convert.jsonDecode(response.body) as Map<String, dynamic>;
      }
    }
    catch(error) {
      print(error);
      return {};
    }
    return {};
  }

  Map<String, String> addApplicationType(Map<String, String> requestHeaders){
    requestHeaders["content-type"] = 'application/json';
    return requestHeaders;
  }
}

