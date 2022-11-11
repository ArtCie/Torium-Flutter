import '../request_sender.dart';

class PatchDevice extends RequestSender {

  Map<String, String> headers = {};
  Map<String, String> body = {};
  String path = "/users/device";

  PatchDevice(userId, deviceToken){
    headers = {
      "trm-user-id": userId
    };

    body = {
      "device_token": deviceToken
    };
  }

  void fetch(){
    patch(path, headers, body);
  }
}