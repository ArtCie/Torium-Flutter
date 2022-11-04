import 'dart:convert';

import '../request_sender.dart';

class PostUserGroup extends RequestSender {
  Map<String, String> headers = {};
  Map<String, String> body = {};
  String path = "/groups";

  PostUserGroup(userId, name, description){
    headers = {
      "trm-admin-id": userId
    };

    body = {
      "name": name,
      "description": description
    };
  }

  Future<Map> fetch(){
    return post(path, headers, body);
  }
}