import '../request_sender.dart';

class GetUserIdByEmail extends RequestSender {
  String email;
  String path = "/users/email";

  GetUserIdByEmail(String this.email);

  Future<Map> fetch(){
    Map<String, String> headers = {
      "trm-email": email
    };
    return get(path, requestHeaders: headers);
  }
}