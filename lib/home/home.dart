import 'package:flutter/material.dart';

import '../utils.dart';


class Home extends StatefulWidget {
  final String userId;

  const Home(this.userId, {super.key});

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<Home> {

  @override
  void initState() {
    super.initState();
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
        backgroundColor: DefaultColors.getDefaultColor(),
      ),
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

}
