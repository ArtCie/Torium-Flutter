import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';

import 'Palette.dart';
import 'authentication/amplify.dart';
import 'home/home.dart';
import 'user_first_login/preferences_screen.dart';
import 'user_first_login/mobile/mobile_number_init.dart';
import 'firebase/firebase_handler.dart';




void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseHandler().configureFirebase();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  if (!kIsWeb) {
    await setupFlutterNotifications();
  }
  await setupInteractedMessage();
  await AmplifyConfigure().configureAmplify();
  runApp(const MyApp());

}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Palette.kToDark,
      ),
      home: const MyHomePage(),
    );
  }

}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Authenticator(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: customLightTheme,
          darkTheme: customDarkTheme,
          themeMode: ThemeMode.system,
          builder: Authenticator.builder(),
          home: Scaffold(
            body: Center(
              child: Home(),
            ),
          ),
          routes: <String, WidgetBuilder> {
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
      primarySwatch: Palette.kToDark,
    ),
    // tab bar indicator color
    indicatorColor: Palette.kToDark,
    textTheme: const TextTheme(
      headline6: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 24,
        color: Colors.white,
      ),
      headlineLarge: TextStyle(color: Color.fromRGBO(25, 44, 80, 1)),
      headline1: TextStyle(color: Color.fromRGBO(25, 44, 80, 1)),
      headline2: TextStyle(color: Color.fromRGBO(25, 44, 80, 1)),
      bodyText2: TextStyle(color: Color.fromRGBO(25, 44, 80, 1)),
      subtitle1: TextStyle(color: Color.fromRGBO(25, 44, 80, 1)),
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
    textTheme: const TextTheme(
      headline6: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 24,
        color: Colors.white,
      ),
      headline1: TextStyle(color: Color.fromRGBO(25, 44, 80, 1)),
      headline2: TextStyle(color: Color.fromRGBO(25, 44, 80, 1)),
      bodyText2: TextStyle(color: Color.fromRGBO(25, 44, 80, 1)),
      subtitle1: TextStyle(color: Color.fromRGBO(25, 44, 80, 1)),
    ),
    colorScheme: ColorScheme.fromSwatch(
      brightness: Brightness.dark,
      primarySwatch: Palette.kToDark,
    ),
    indicatorColor: Palette.kToDark,
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
