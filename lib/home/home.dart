import 'package:flutter/material.dart';
import 'package:torium/authentication/amplify.dart';
import 'package:torium/home/settings_screen.dart';
import 'package:badges/badges.dart';

import '../api/groups/invitations/get_invitations_count.dart';

import '../utils.dart';
import 'navigator_bar_screens/groups_screen.dart';
import 'navigator_bar_screens/notification_screen/notification_screen.dart';

class Home extends StatefulWidget {

  Home({super.key});

  @override
  MyHomeState createState() => MyHomeState();
}

class MyHomeState extends State<Home> {
  int _selectedIndex = 0;
  bool hasNotificationsToShow = false;
  int numberOfNotifications = 0;

  final screens = [
    GroupsScreen(),
    GroupsScreen(),
    NotificationScreen()
  ];

  String? userId;

  @override
  void initState() {
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    userId = (await AmplifyConfigure.getUserId())!;
    await getInvitationCount(userId);
    super.didChangeDependencies();
  }

  getInvitationCount(String? userId) async {
    var result = await GetInvitationsCount(userId!).fetch();
    int notificationCount = result["data"]["count"];
    if(notificationCount != 0){
      setState(() {
        hasNotificationsToShow = true;
        numberOfNotifications = notificationCount;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: screens[_selectedIndex],
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  void redirectAction(String? action){
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

  AppBar buildAppBar({bool isProfile = true}) {
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


  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: Icon(
              IconData(0xe2eb, fontFamily: 'MaterialIcons')
          ),
          label: 'Groups',
        ),
        const BottomNavigationBarItem(
            icon: Icon(
                IconData(0xe23e, fontFamily: 'MaterialIcons')
            ),
            label: 'Events'
        ),
        buildNotificationNavigationBar(),
      ],
      backgroundColor: DefaultColors.getDefaultColor(),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.black87,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if(index == 2){
        hasNotificationsToShow = false;
      }
    });
  }

  BottomNavigationBarItem buildNotificationNavigationBar(){
    return BottomNavigationBarItem(
      icon: hasNotificationsToShow ? Badge(
        badgeContent: Text(numberOfNotifications.toString()),
        child: const Icon(
                IconData(0xf0027, fontFamily: 'MaterialIcons')
            ),
      ) : const Icon(
          IconData(0xf0027, fontFamily: 'MaterialIcons')
      ),
      label: 'Notifications'
    );
  }
}
