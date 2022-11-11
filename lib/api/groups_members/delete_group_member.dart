import '../request_sender.dart';

class DeleteGroupMember extends RequestSender {
  int userId;
  int groupId;
  String path = "/group/members";

  DeleteGroupMember(this.userId, this.groupId);

  Future<Map> fetch(){
    Map<String, String> headers = {
      "trm-user-id": userId.toString(),
      "trm-group-id": groupId.toString()
    };
    return delete(path, headers, {});
  }
}