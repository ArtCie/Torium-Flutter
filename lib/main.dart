import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:torium/user_first_login/screen_manager.dart';
import 'autentication/amplify.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'user_first_login/preferences_screen.dart';
import 'user_first_login/mobile/mobile_number_init.dart';
import 'home/logging.dart';
import 'firebase/firebase_handler.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async{
  await Firebase.initializeApp();
  }

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await AmplifyConfigure().configureAmplify();
  await FirebaseHandler().configureFirebase();
  runApp(const MyApp());

}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }

  // void initMessaging() {
  //   FirebaseMessaging messaging = FirebaseMessaging.instance;
  //   FlutterLocalNotificationsPlugin? fltNotification;
  //   var androiInit = AndroidInitializationSettings("@mipmap/ic_launcher");
  //   // var iosInit = IOSInitializationSettings();
  //   // var initSetting = InitializationSettings(android: androiInit, iOS: iosInit);
  //   var initSetting = InitializationSettings(android: androiInit);
  //   fltNotification = FlutterLocalNotificationsPlugin();
  //   fltNotification.initialize(initSetting);
  //   var androidDetails =
  //   AndroidNotificationDetails("1", "channelName");
  //   // var iosDetails = IOSNotificationDetails();
  //   var generalNotificationDetails =
  //   // NotificationDetails(android: androidDetails, iOS: iosDetails);
  //   NotificationDetails(android: androidDetails);
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     RemoteNotification? notification=message.notification;
  //     AndroidNotification? android=message.notification?.android;
  //     if(notification!=null && android!=null){
  //       fltNotification?.show(
  //           notification.hashCode, notification.title, notification.body, generalNotificationDetails);
  //     }});}
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Authenticator(
        child: MaterialApp(
          theme: customLightTheme,
          darkTheme: customDarkTheme,
          themeMode: ThemeMode.system,
          builder: Authenticator.builder(),
          home: const Scaffold(
            body: Center(
              child: Logging(),
            ),
          ),
          routes: <String, WidgetBuilder> {
            '/first_login': (BuildContext context) => ScreenManager(),
            '/preferences': (BuildContext context) => PreferencesScreen(),
            '/mobile_number_init': (BuildContext context) => MobileNumberInit()
          },
        )
    );
  }

// light theme
  ThemeData customLightTheme = ThemeData(
    fontFamily: 'Poppins',
    // app's colors scheme and brightness
    colorScheme: ColorScheme.fromSwatch(
      brightness: Brightness.light,
      primarySwatch: Colors.teal,
    ),
    // tab bar indicator color
    indicatorColor: Colors.teal,
    textTheme: const TextTheme(
      // text theme of the header on each step
      headline6: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 24,
      ),
    ),
    // theme of the form fields for each step
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(16),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.grey[200],
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
    // theme of the primary button for each step
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(16)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    ),
  );

// dark theme
  ThemeData customDarkTheme = ThemeData(
    fontFamily: 'Poppins',
    colorScheme: ColorScheme.fromSwatch(
      brightness: Brightness.dark,
      primarySwatch: Colors.teal,
    ),
    indicatorColor: Colors.teal,
    textTheme: const TextTheme(
      headline6: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 24,
        color: Colors.white,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(16),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.grey[700],
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(16)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    ),
  );
}