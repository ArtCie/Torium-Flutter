import 'package:flutter/material.dart';

import 'home/home.dart';

class DefaultColors {
    static Color? getDefaultColor() {
      return Colors.teal[300];
    }
}


class DefaultWidgets extends MyHomeState {
  AppBar get({bool isProfile = true}) {
    return AppBar(
      title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image.asset(
          'assets/yellow.png',
          fit: BoxFit.cover,
          height: 50,
          width: 50,
        ),
        const Text(
          'Torium',
          style: TextStyle(
              letterSpacing: 5, fontSize: 20, color: Colors.black87),
        ),
      ]),
      backgroundColor: DefaultColors.getDefaultColor(),
      actions: <Widget>[getProfileAction(isProfile)],
    );
  }

  Visibility getProfileAction(bool isProfile) {
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
                redirectAction(item);
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

  static Align buildHeader(String text, {double vertical = 30.0, Alignment alignment = Alignment.center}){
    return Align(
      alignment: alignment,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: vertical, horizontal: 40.0),
        child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.bold,
                fontSize: 25)
        ),
      ),
    );
  }
}