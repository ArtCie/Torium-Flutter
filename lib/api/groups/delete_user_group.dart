import '../request_sender.dart';

class DeleteUserGroup extends RequestSender {
  String userId;
  int id;
  String path = "/groups";

  DeleteUserGroup(this.userId, this.id);

  Future<Map> fetch(){
    Map<String, String> headers = {
      "trm-admin-id": userId
    };

    Map<String, int> body = {
      "id": id
    };
  return delete(path, headers, body);
  }
}