import '../request_sender.dart';

class GetAllEvents extends RequestSender {
  String userId;
  String path = "/event";

  GetAllEvents(this.userId);

  Future<Map> fetch(){
    Map<String, String> headers = {
      "trm-user-id": userId
    };
    return get(path, requestHeaders: headers);
  }
}