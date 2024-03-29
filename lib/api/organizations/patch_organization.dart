import 'dart:convert';

import '../request_sender.dart';

class PatchOrganization extends RequestSender {
  Map<String, String> headers = {};
  Map<String, String> body = {};
  String path = "/users/organization";

  PatchOrganization(userId, organizationId){
    headers = {
      "trm-user-id": userId
    };

    body = {
      "organization_id": organizationId.toString()
    };
  }

  Future<Map> fetch(){
    return patch(path, headers, body);
  }
}