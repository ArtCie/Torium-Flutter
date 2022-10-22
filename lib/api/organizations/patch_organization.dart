import 'dart:convert';

import '../request_sender.dart';

class PatchOrganization extends RequestSender {
  Map<String, String> headers = {};
  Map<String, String> body = {};
  String path = "/users/mobile";

  PatchUpdateMobilePhone(userId, organizationId){
    headers = {
      "trm-user-id": userId
    };

    body = {
      "organization_id": organizationId
    };
  }

  Future<Map> fetch(){
    return patch(path, headers, body);
  }
}