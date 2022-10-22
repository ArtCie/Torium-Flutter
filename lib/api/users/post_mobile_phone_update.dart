import 'dart:convert';

import '../request_sender.dart';

class PostMobilePhoneUpdate extends RequestSender {
  Map<String, String> headers = {};
  Map<String, String> body = {};
  String path = "/users/mobile";

  PostMobilePhoneUpdate(userId, phoneNumber){
    headers = {
      "trm-user-id": userId
    };

    body = {
      "mobile_number": phoneNumber
    };
  }

  Future<Map> fetch(){
    return post(path, headers, body);
  }
}