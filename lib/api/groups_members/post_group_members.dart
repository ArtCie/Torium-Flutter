import 'dart:convert';

import '../request_sender.dart';

class PostGroupMembers extends RequestSender {
  Map<String, String> headers = {};
  String path = "/group/members";

  PostGroupMembers(userId, groupId){
    headers = {
      "trm-user-id": userId.toString(),
      "trm-group-id": groupId.toString()
    };
  }

  Future<Map> fetch(){
    return post(path, headers, {});
  }
}