import '../../request_sender.dart';

class GetInvitations extends RequestSender {
  String userId;
  String path = "/groups/invitation";

  GetInvitations(String this.userId);

  Future<Map> fetch(){
    Map<String, String> headers = {
      "trm-user-id": userId
    };
    return get(path, requestHeaders: headers);
  }
}