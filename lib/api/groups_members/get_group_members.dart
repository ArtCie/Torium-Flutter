import '../request_sender.dart';

class GetGroupMembers extends RequestSender {
  String userId;
  String groupId;
  String path = "/group/members";

  GetGroupMembers(this.userId, this.groupId);

  Future<Map> fetch(){
    Map<String, String> headers = {
      "trm-user-id": userId,
      "trm-group-id": groupId
    };
    return get(path, requestHeaders: headers);
  }
}