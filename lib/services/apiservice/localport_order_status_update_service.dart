import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:localport_alter_delivery/SharedPreferences/sharedpreferences_class.dart';
import 'package:localport_alter_delivery/resources/server_urls.dart';

class LocalportOrderStatusUpdateService with ChangeNotifier {
  Future updateStatus(String oid, String status, String uid) async {
    String partnerid = await SharedPreferencesClass().getUid();
    Uri url = Uri.parse(updateorderstatus);
    Map<String, String> header = {
      "Content-type": "application/json",
    };
    String body =
        '{"oid":"$oid", "status":"$status", "uid":"$uid", "partnerid":"$partnerid"}';
    print(body);
    Response response = await post(url, headers: header, body: body);
    var data = json.decode(response.body);
    print(data);
    bool resStatus = data['status'];
    String errorcode = data['errorcode'];

    print(response.body);

    return errorcode;
  }
}
