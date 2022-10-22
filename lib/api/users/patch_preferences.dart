import 'dart:convert';

import '../request_sender.dart';

class PatchPreferences extends RequestSender {
  Map<String, String> headers = {};
  Map<String, String> body = {};
  String path = "/users/preferences";

  PatchPreferences(userId, reminder_preferences){
    headers = {
      "trm-user-id": userId
    };

    body = {
      "reminder_preferences": reminder_preferences
    };
  }

  Future<Map> fetch(){
    return patch(path, headers, body);
  }
}