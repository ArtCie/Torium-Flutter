import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';


class FirebaseHandler {


  Future<void> configureFirebase() async {
    await Firebase.initializeApp();
    final fcmToken = await FirebaseMessaging.instance.getToken();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('device_token', fcmToken!);
    print("CONFIGURE FIREBASE");
    print(fcmToken);
  }

}
