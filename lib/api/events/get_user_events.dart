import '../request_sender.dart';

class GetUserEvents extends RequestSender {
  String userId;
  String path = "/event";

  GetUserEvents(String this.userId);

  Future<Map> fetch(){
    Map<String, String> headers = {
      "trm-user-id": userId
    };
    return get(path, requestHeaders: headers);
  }
}