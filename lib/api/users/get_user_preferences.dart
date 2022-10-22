import '../request_sender.dart';

class GetUserPreferences extends RequestSender {
  String userId;
  String path = "/users";

  GetUserPreferences(String this.userId);

  Future<Map> fetch(){
    Map<String, String> headers = {
      "trm-user-id": userId
    };
    return get(path, requestHeaders: headers);
  }
}