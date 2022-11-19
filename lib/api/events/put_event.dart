import '../request_sender.dart';

class PutEvent extends RequestSender {
  Map<String, String> schedulePeriodMap = {
    "1 day, 0:00:00": "1 day",
    "7 days, 0:00:00": "1 week",
    "30 days, 0:00:00": "1 month"
  };
  Map<String, String> headers = {};
  Map<String, dynamic> body = {};
  String path = "/event";

  PutEvent(id, userId, isBudget, budget,
              description, eventTimestamp, reminder,
              schedulePeriod, users, name, groupId){
    headers = {
      "trm-user-id": userId.toString()
    };
    print(users);
    body = {
      "id": id,
      "is_budget": isBudget,
      "budget": budget,
      "description": description,
      "event_timestamp": eventTimestamp,
      "reminder": reminder,
      "schedule_period": schedulePeriodMap[schedulePeriod],
      "users": users,
      "name": name,
      "group_id": groupId
    };
  }

  Future<Map> fetch(){
    return put(path, headers, body);
  }
}