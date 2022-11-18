import '../request_sender.dart';

class PutEventComment extends RequestSender {
  Map<String, String> headers = {};
  Map<String, dynamic> body = {};
  String path = "/event/comment";

  PutEventComment(id, userId, comment){
    headers = {
      "trm-user-id": userId.toString()
    };

    body = {
      "comment": comment,
      "id": id
    };
  }

  Future<Map> fetch(){
    return put(path, headers, body);
  }
}