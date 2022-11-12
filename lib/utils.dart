import 'package:flutter/material.dart';

import 'authentication/amplify.dart';
import 'home/home.dart';
import 'home/settings_screen.dart';

class DefaultColors {
    static Color? getDefaultColor({double opacity = 1.0}) {
      return Colors.blue.shade800.withOpacity(opacity);
    }
}


class DefaultWidgets extends MyHomeState {
  AppBar buildAppBar({context, bool isProfile = true}) {
    return AppBar(
      centerTitle: true,
      title: const Text(
        'Torium',
        style: TextStyle(
            letterSpacing: 5, fontSize: 20, color: Colors.black87),
        textAlign: TextAlign.center,
      ),
      backgroundColor: DefaultColors.getDefaultColor(),
      actions: <Widget>[getProfileAction(context, isProfile)],
    );
  }

  Visibility getProfileAction(context, bool isProfile) {
    return Visibility(
      visible: isProfile,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),

        child: PopupMenuButton(
            icon: const Icon(
              IconData(0xf522, fontFamily: 'MaterialIcons'),
              color: Colors.white,
              size: 35,
            ),
            onSelected: (item) {
              redirectAction(context, item);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              const PopupMenuItem(
                value: "Settings",
                child: Text('Settings'),
              ),
              const PopupMenuItem(
                value: "Log out",
                child: Text('Log out'),
              ),
            ]
        ),
      ),
    );
  }

  void redirectAction(context, String? action){
    if(action == "Log out"){
      AmplifyConfigure.logOut();
    }
    else{
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SettingsScreen()),
      );
    }
  }


  static SnackBar getErrorSnackBar() {
    return SnackBar(
      content: const Text('Something went wrong :('),
      action: SnackBarAction(
        label: 'ok :<',
        onPressed: () {  }
      )
    );
  }

  static SnackBar getErrorSnackBarParam(String text) {
    return SnackBar(
        content: Text(text)
    );
  }

  static Align buildHeader(String text, {double vertical = 30.0, Alignment alignment = Alignment.center, double? fontSize = 25}){
    return Align(
      alignment: alignment,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: vertical, horizontal: 20.0),
        child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.bold,
                fontSize: fontSize)
        ),
      ),
    );
  }

  static Align buildInfoHeader(String text, {double? fontSize = 14}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 5),
        child: Text(text,
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey[500],
                fontWeight: FontWeight.w600,
                fontSize: fontSize)),
      ),
    );
  }
}