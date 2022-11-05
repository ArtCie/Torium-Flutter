import '../../request_sender.dart';

class GetInvitationsCount extends RequestSender {
  String userId;
  String path = "/groups/invitation/count";

  GetInvitationsCount(String this.userId);

  Future<Map> fetch(){
    Map<String, String> headers = {
      "trm-user-id": userId
    };
    return get(path, requestHeaders: headers);
  }
}