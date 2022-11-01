import '../request_sender.dart';

class GetUserGroups extends RequestSender {
  String userId;
  String path = "/groups";

  GetUserGroups(String this.userId);

  Future<Map> fetch(){
    Map<String, String> headers = {
      "trm-user-id": userId
    };
    return get(path, requestHeaders: headers);
  }
}