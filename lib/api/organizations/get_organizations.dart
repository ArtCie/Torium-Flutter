import '../request_sender.dart';

class GetUserPreferences extends RequestSender {
  final String path = "/organizations";

  GetUserPreferences();

  Future<Map> fetch(){
    return get(path);
  }
}