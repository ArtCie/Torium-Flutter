import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import '../autentication/amplify.dart';

import 'loading_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? userId;
  List pages = [
    LoadingScreen.getLoadingScreen(),
    'groups',
    'events'
  ];
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  Future<void> getUserId() async {
    var userAttributes = await AmplifyConfigure.getUserAttribute();

    for (var attributes in userAttributes) {
      if (attributes.userAttributeKey ==
          const CognitoUserAttributeKey.custom('custom:user_id')) {
        setState(() {
          userId = attributes.value;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
            child: IconButton(
              icon: const Icon(
                IconData(0xf522, fontFamily: 'MaterialIcons'),
                color: Colors.white,
                size: 35,
              ),
              onPressed: () {},
            ),
          )
        ],
        backgroundColor: Colors.teal[300],
      ),
      body: SafeArea(child: pages[currentPage]),
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
        backgroundColor: Colors.teal[300],
        selectedItemColor: Colors.yellow,
        unselectedItemColor: Colors.black87,
      ),
    );
  }
}
