import 'dart:convert';

import '../request_sender.dart';

class PatchStatusGroupMembers extends RequestSender {
  Map<String, String> headers = {};
  Map<String, String> body = {};
  String path = "/group/members/status";

  PatchStatusGroupMembers(userId, groupId, status){
    headers = {
      "trm-user-id": userId,
      "trm-group-id": groupId.toString()
    };

    body = {
      "status": status
    };
  }

  Future<Map> fetch(){
    return patch(path, headers, body);
  }
}