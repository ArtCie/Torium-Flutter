import 'package:flutter/material.dart';
import 'package:torium/autentication/amplify.dart';
import 'package:torium/home/settings_screen.dart';

import '../utils.dart';


class Home extends StatefulWidget {
  final String userId;

  const Home(this.userId, {super.key});

  @override
  MyHomeState createState() => MyHomeState();
}

class MyHomeState extends State<Home> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: const SafeArea(child: Text('HOME SCREEN')),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
                IconData(0xe2eb, fontFamily: 'MaterialIcons')
            ),
            label: 'Groups',),
          BottomNavigationBarItem(
              icon: Icon(
                  IconData(0xe23e, fontFamily: 'MaterialIcons')
              ),
              label: 'Events')
        ],
        backgroundColor: DefaultColors.getDefaultColor(),
        selectedItemColor: Colors.yellow,
        unselectedItemColor: Colors.black87,
      ),
    );
  }



  void redirectAction(String? action){
    if(action == "Log out"){
      AmplifyConfigure.logOut();
    }
    else{
      print(widget.userId);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SettingsScreen()),
      );
    }
  }

  AppBar getAppBar({bool isProfile = true}) {
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
}
