import 'package:flutter/material.dart';
import 'package:torium/autentication/amplify.dart';
import 'package:torium/home/settings_screen.dart';

import '../utils.dart';
import 'content_loaders/group.dart';
import '../../api/groups/get_user_groups.dart';
import 'loading_screen.dart';


class Home extends StatefulWidget {

  Home({super.key});

  @override
  MyHomeState createState() => MyHomeState();
}

class MyHomeState extends State<Home> {

  String? userId;
  bool isLoaded = false;
  List<Group> userGroups = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    print("JAZDA");
    userId = (await AmplifyConfigure.getUserId())!;
    await GetUserGroups(userId!).fetch().then((result) async {
      setState(() {
        print(result.toString());
        for (var group in result["data"]) {
          userGroups.add(Group(
              group["admin_id"], group["group_id"],
              group["name"], group["status"]));
        }
        isLoaded = true;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 30.0, horizontal: 40.0),
                child: Text(
                    "Groups",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 25)
                ),
              ),
              Expanded(child:
                isLoaded == false ? LoadingScreen.getScreen() : buildGroupsScreen()
              ),
            ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("OKAY LET'S GO");
        },
        backgroundColor: DefaultColors.getDefaultColor(),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
              IconData(0xe2eb, fontFamily: 'MaterialIcons')
          ),
          label: 'Groups',
        ),
        BottomNavigationBarItem(
            icon: Icon(
                IconData(0xe23e, fontFamily: 'MaterialIcons')
            ),
            label: 'Events'
        )
      ],
      backgroundColor: DefaultColors.getDefaultColor(),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.black87,
    );
  }



  void redirectAction(String? action){
    if(action == "Log out"){
      AmplifyConfigure.logOut();
    }
    else{
      print(userId);
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

  ListView buildGroupsScreen() {
    return ListView.builder(
      itemCount: userGroups.length,
      itemBuilder: (_, index) {
        return Card(
          child: Container(
            alignment: Alignment.centerLeft,
            height: 120,
            child: ListTile(
                // leading: settingTypes[index].icon,
                title: Text(userGroups[index].name),
                // subtitle: Text(settingTypes[index].value),
                trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget> [
                      Visibility(
                        visible: userGroups[index].status != "standard",
                        child: IconButton(
                          icon: const Icon(
                              IconData(0xf6fb, fontFamily: 'MaterialIcons',
                              matchTextDirection: true)
                                ),
                          onPressed: () { print("DUPA"); },
                        ),
                      ),
                      Visibility(
                        visible: userGroups[index].status == "admin",
                        child: IconButton(
                          icon: const Icon(
                              IconData(0xf645, fontFamily: 'MaterialIcons',
                                  matchTextDirection: true)
                          ),
                          onPressed: () { print("DUPA"); },
                        ),
                      )
                  ]
                ),
                onTap: () {

                }  // Handle your onTap here.
            ),
          ),
        );
      },
    );
  }
}
