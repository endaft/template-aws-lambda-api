import 'dart:convert';

import 'package:endaft_core/server.dart';

import 'user_data.dart';

extension RequestFactories on AwsApiGatewayEvent {
  UserData getUserData() {
    if (headers == null) {
      throw SecurityError('Cannot access unavailable security headers.');
    }
    return UserData.fromHeaders(headers!.raw);
  }

  String getUserId() {
    final userData = getUserData();
    return userData.id;
  }

  Map<String, dynamic> getJsonBody() {
    if (body == null || body!.isEmpty) {
      throw ArgumentError.notNull("body");
    }
    return jsonDecode(body!) as Map<String, dynamic>;
  }
}
