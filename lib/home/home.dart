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
      appBar: DefaultWidgets().buildAppBar(),
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


  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        buildBottomNavigationBarItem('Groups', 0xe2eb),
        buildBottomNavigationBarItem('Events', 0xe23e),
        buildBottomNavigationBarItem('Calendar', 0xf06c8),
        buildNotificationNavigationBar(),
      ],
      backgroundColor: DefaultColors.getDefaultColor(),
      selectedItemColor: Colors.black38,
      unselectedItemColor: Colors.black87,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }

  BottomNavigationBarItem buildBottomNavigationBarItem(String text, var icon){
    return BottomNavigationBarItem(
        icon: Icon(
            IconData(icon, fontFamily: 'MaterialIcons')
        ),
        label: text
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
