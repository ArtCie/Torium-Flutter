import 'dart:convert';

import '../request_sender.dart';

class PostEvent extends RequestSender {
  Map<String, String> headers = {};
  Map<String, dynamic> body = {};
  String path = "/event";

  PostEvent(groupId, isBudget, budget, description,
            eventTimestamp, reminder,
            schedulePeriod, users, name){
    headers = {
      "trm-group-id": groupId.toString()
    };

    body = {
      "is_budget": isBudget,
      "budget": budget,
      "description": description,
      "event_timestamp": eventTimestamp,
      "reminder": reminder,
      "schedule_period": schedulePeriod,
      "users": users,
      "name": name
    };
  }

  Future<Map> fetch(){
    return post(path, headers, body);
  }
}