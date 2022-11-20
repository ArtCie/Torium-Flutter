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
      iconTheme: IconThemeData(
        color: DefaultColors.getDefaultColor(), //change your color here
      ),
      elevation: 0,
      centerTitle: false,
      title: Image.asset('assets/logo.png', fit: BoxFit.cover,
          height: 30,
          width: 30),
      backgroundColor: Colors.grey[50],
      actions: <Widget>[getProfileAction(context, isProfile)],
    );
  }

  Visibility getProfileAction(context, bool isProfile) {
    return Visibility(
      visible: isProfile,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),

        child: PopupMenuButton(
            icon: Icon(
              const IconData(0xf522, fontFamily: 'MaterialIcons'),
              color: DefaultColors.getDefaultColor(),
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

  static Align buildHeader(String text, {double bottom = 30.0, Alignment alignment = Alignment.center, double? fontSize = 25, double top = 20.0}){
    return Align(
      alignment: alignment,
      child: Padding(
        // padding: EdgeInsets.symmetric(vertical: vertical, horizontal: 20.0),
        padding: EdgeInsets.fromLTRB(20, top, 20, bottom),
        child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: fontSize)
        ),
      ),
    );
  }

  static Align buildInfoHeader(String text, {double? fontSize = 14, double top = 15, fontWeight = FontWeight.w600}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, top, 20, 5),
        child: Text(text,
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Color.fromRGBO(35, 54, 92, 0.6),
                fontWeight: fontWeight,
                fontSize: fontSize)),
      ),
    );
  }

  static Card buildDefaultCard(title, {trailing}){
    return Card(
      child: ListTile(
          contentPadding:
          const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14.0),
          title: title,
          trailing: trailing,
          onTap: null),
    );
  }
}