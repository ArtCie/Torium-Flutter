import 'package:flutter/material.dart';
import 'package:torium/autentication/amplify.dart';

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
      appBar: DefaultAppBar().get(),
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

  void redirectAction(String action){
    if(action == "Log out"){
      AmplifyConfigure.logOut();
    }
  }
}
