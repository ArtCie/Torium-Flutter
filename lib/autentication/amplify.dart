import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../amplifyconfiguration.dart';


class AmplifyConfigure {

  String userId = "";

  static Future<void> configureAmplify() async {
    try {
      final auth = AmplifyAuthCognito();
      await Amplify.addPlugin(auth);

      await Amplify.configure(amplifyconfig);
    } on Exception catch (e) {
      print('An error occurred configuring Amplify: $e');
    }
  }

  static Future<List<AuthUserAttribute>> getUserAttribute() async {
    // Amplify.Auth.signOut();
    final userAttributes = await Amplify.Auth.fetchUserAttributes();
    for (var attributes in userAttributes) {
      if (attributes.userAttributeKey ==
          const CognitoUserAttributeKey.custom('custom:user_id')) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', attributes.value);
      }
    }
    return userAttributes;
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('user_id');
    return userId;
  }

  // static Future<AuthUser> getCurrentUser() async {
  //     Amplify.Auth.fetchAuthSession();
  //     final user = await Amplify.Auth.getCurrentUser();
  //     return user;
  // }
}
