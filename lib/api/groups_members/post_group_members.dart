import 'dart:convert';

import '../request_sender.dart';

class PostGroupMembers extends RequestSender {
  Map<String, String> headers = {};
  String path = "/groups/members";

  PostGroupMembers(userId, groupId){
    headers = {
      "trm-user-id": userId,
      "trm-group-id": groupId
    };
  }

  Future<Map> fetch(){
    return postEmpty(path, headers);
  }
}