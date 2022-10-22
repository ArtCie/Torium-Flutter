import 'package:flutter/material.dart';

class DefaultColors {
    static Color? getDefaultColor() {
      return Colors.teal[300];
    }
}

class DefaultAppBar {
  static AppBar get({bool isProfile = true}) {
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
      actions: <Widget>[
        Visibility(
          visible: isProfile,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
            child: IconButton(
              icon: const Icon(
                IconData(0xf522, fontFamily: 'MaterialIcons'),
                color: Colors.white,
                size: 35,
              ),
              onPressed: () {},
            ),
          ),
        )
      ],
    );
  }
}