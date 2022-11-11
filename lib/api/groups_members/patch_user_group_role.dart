import '../request_sender.dart';

class PatchUserGroupRole extends RequestSender {
  Map<String, String> headers = {};
  Map<String, dynamic> body = {};
  String path = "/group/members/role";

  PatchUserGroupRole(userId, adminId, groupId, status){
    headers = {
      "trm-admin-id": adminId.toString(),
      "trm-group-id": groupId.toString()
    };

    body = {
      "status": status,
      "user_id": userId
    };
  }

  Future<Map> fetch(){
    return patch(path, headers, body);
  }
}