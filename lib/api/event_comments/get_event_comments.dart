import '../request_sender.dart';

class GetEventComments extends RequestSender {
  String eventId;
  String path = "/event/comment";

  GetEventComments(this.eventId);

  Future<Map> fetch(){
    Map<String, String> headers = {
      "trm-event-id": eventId,
    };
    return get(path, requestHeaders: headers);
  }
}