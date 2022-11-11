import 'dart:convert';

import '../request_sender.dart';

class PutUserGroup extends RequestSender {
  Map<String, String> headers = {};
  Map<String, dynamic> body = {};
  String path = "/groups";

  PutUserGroup(id, userId, name, description){
    headers = {
      "trm-admin-id": userId.toString()
    };

    body = {
      "name": name,
      "description": description,
      "admin_id": userId,
      "id": id
    };
  }

  Future<Map> fetch(){
    return put(path, headers, body);
  }
}