import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../api/groups/delete_user_group.dart';
import '../api/groups/get_user_groups.dart';
import '../autentication/amplify.dart';
import '../utils.dart';
import 'group_screens/add_group/add_group_screen.dart';
import 'group_screens/add_group/group.dart';
import 'loading_screen.dart';

class GroupsScreen extends StatefulWidget{
  const GroupsScreen({Key? key}) : super(key: key);
  
  State<GroupsScreen> createState() => _GroupsState();
}

class _GroupsState extends State<GroupsScreen>{
  String? userId;
  bool isLoaded = false;
  List<Group> userGroups = [];

  void initState() {
    super.initState();
    print("TEST GROUPS");
  }

  @override
  Future<void> didChangeDependencies() async {
    userId = (await AmplifyConfigure.getUserId())!;
    await GetUserGroups(userId!).fetch().then((result) async {
      setState(() {
        userGroups = [];
        for (var group in result["data"]) {
          userGroups.add(Group(
              group["admin_id"], group["group_id"],
              group["name"], group["description"], group["status"]));
        }
        isLoaded = true;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddGroupScreen(userId: userId!)),
          ).then(onGoBack);

        },
        backgroundColor: DefaultColors.getDefaultColor(),
        child: const Icon(Icons.add),
      ),
    );
  }

  onGoBack(dynamic value) {
    didChangeDependencies();
  }

  ListView buildGroupsScreen() {
    return ListView.builder(
      itemCount: userGroups.length,
      itemBuilder: (_, index) {
        return Card(
          child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 14.0),
              title: Text(userGroups[index].name),
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
                        onPressed: () {
                          QuickAlert.show(
                              context: context,
                              type: QuickAlertType.error,
                              text: 'Do you want to remove ${userGroups[index].name}?',
                              confirmBtnText: 'Yes',
                              cancelBtnText: 'No',
                              confirmBtnColor: Colors.red,
                              showCancelBtn: true,
                              onConfirmBtnTap: () {
                                deleteGroup(index);
                              }
                          );
                        },
                      ),
                    )
                  ]
              ),
              onTap: () {

              }  // Handle your onTap here.
          ),
        );
      },
    );
  }

  void deleteGroup(int index) {
    Navigator.of(context, rootNavigator: true).pop();
    DeleteUserGroup(userId!, userGroups[index].groupId).fetch().then((result){
      if(result["status"]["code"] != 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            DefaultWidgets.getErrorSnackBar()
        );
        return;
      }
      setState(() {
        userGroups.removeAt(index);
      });
    });
  }
  
}