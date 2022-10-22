import 'dart:convert';

import '../request_sender.dart';

class PatchUpdateMobilePhone extends RequestSender {
  Map<String, String> headers = {};
  Map<String, String> body = {};
  String path = "/users/mobile";

  PatchUpdateMobilePhone(userId, code){
    headers = {
      "trm-user-id": userId
    };

    body = {
      "code": code
    };
  }

  Future<Map> fetch(){
    return patch(path, headers, body);
  }
}