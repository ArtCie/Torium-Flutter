import '../request_sender.dart';

class GetUserEvents extends RequestSender {
  String userId;
  String groupId;
  String path = "/event";

  GetUserEvents(this.userId, this.groupId);

  Future<Map> fetch(){
    Map<String, String> headers = {
      "trm-user-id": userId,
      "trm-group-id": groupId
    };
    return get(path, requestHeaders: headers);
  }
}