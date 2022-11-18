import '../request_sender.dart';

class DeleteEventComment extends RequestSender {
  String userId;
  int id;
  String path = "/event/comment";

  DeleteEventComment(this.userId, this.id);

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