import '../request_sender.dart';

class PostEventComment extends RequestSender {
  Map<String, String> headers = {};
  Map<String, String> body = {};
  String path = "/event/comment";

  PostEventComment(userId, event_id, comment){
    headers = {
      "trm-user-id": userId
    };

    body = {
      "event_id": event_id,
      "comment": comment
    };
  }

  Future<Map> fetch(){
    return post(path, headers, body);
  }
}