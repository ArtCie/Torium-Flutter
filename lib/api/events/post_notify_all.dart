import 'dart:convert';

import '../request_sender.dart';

class PostNotifyAll extends RequestSender {
  Map<String, String> headers = {};
  Map<String, dynamic> body = {};
  String path = "/event/notify";

  PostNotifyAll(userId, eventId){
    headers = {
      "trm-user-id": userId.toString()
    };

    body = {
      "event_id": eventId
    };
  }

  Future<Map> fetch(){
    return post(path, headers, body);
  }
}