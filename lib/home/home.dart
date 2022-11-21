import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:torium/authentication/amplify.dart';
import 'package:torium/home/navigator_bar_screens/event_base_screen.dart';
import 'package:badges/badges.dart';

import '../api/groups/invitations/get_invitations_count.dart';

import '../api/users/get_user_preferences.dart';
import '../api/users/patch_device.dart';
import '../user_first_login/organizations/organization_screen.dart';
import '../utils.dart';
import 'navigator_bar_screens/calendar_screen.dart';
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
    EventBaseScreen(),
    CalendarScreen(),
    NotificationScreen()
  ];

  String? userId;

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    userId = await getUserId();
    getUserPreferences().then((data) {
      setState(() {
        checkDeviceToken(data);
        if(data["data"]["reminder_preferences"] == null){
          Navigator.pushReplacementNamed(context, '/preferences');
        }
        else if(data["data"]["organization_id"] == null){
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => OrganizationScreen(userId!),
              ));
        }
      });
    });
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
      appBar: DefaultWidgets().buildAppBar(context: context),
      body: screens[_selectedIndex],
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }



  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(

      items: <BottomNavigationBarItem>[
        buildBottomNavigationBarItem('Groups', 0xe2eb),
        buildBottomNavigationBarItem('Events', 0xe23e),
        buildBottomNavigationBarItem('Calendar', 0xf06c8),
        buildNotificationNavigationBar(),
      ],
      backgroundColor: Colors.white,
      selectedItemColor: const Color.fromRGBO(35, 54, 92, 1),
      unselectedItemColor: DefaultColors.getDefaultColor(),
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }

  BottomNavigationBarItem buildBottomNavigationBarItem(String text, var icon){
    return BottomNavigationBarItem(
        icon: Icon(
            IconData(icon, fontFamily: 'MaterialIcons'),
          color: const Color.fromRGBO(35, 54, 92, 0.5)
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
                IconData(0xf0027, fontFamily: 'MaterialIcons'),
            color: Color.fromRGBO(35, 54, 92, 0.5)
            ),
      ) : const Icon(
          IconData(0xf0027, fontFamily: 'MaterialIcons'),
          color: Color.fromRGBO(35, 54, 92, 0.5)
      ),
      label: 'Notifications'
    );
  }

  Future<String> getUserId() async {
    var userAttributes = await AmplifyConfigure.getUserAttribute();
    for (var attributes in userAttributes) {
      if (attributes.userAttributeKey ==
          const CognitoUserAttributeKey.custom('custom:user_id')) {
        return attributes.value;
      }
    }
    return '';
  }

  Future<Map> getUserPreferences() async {
    GetUserPreferences getUserPreferences = GetUserPreferences(userId!);
    Map<dynamic, dynamic> fetchedData = await getUserPreferences.fetch();
    return fetchedData;
  }

  Future<void> checkDeviceToken(Map data) async {
    final prefs = await SharedPreferences.getInstance();
    final String? deviceToken = prefs.getString('device_token');
    print(deviceToken);
    print(data["data"]["device_token"]);
    if(data["data"]["device_token"] != deviceToken){
      PatchDevice(userId, deviceToken).fetch();
    }
  }
}
