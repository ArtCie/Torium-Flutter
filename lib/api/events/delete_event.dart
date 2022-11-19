import '../request_sender.dart';

class DeleteEvent extends RequestSender {
  String userId;
  int id;
  String path = "/event";

  DeleteEvent(this.userId, this.id);

  Future<Map> fetch(){
    Map<String, String> headers = {
      "trm-user-id": userId
    };

    Map<String, int> body = {
      "id": id
    };
    return delete(path, headers, body);
  }
}