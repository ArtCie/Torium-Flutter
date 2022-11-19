import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../api/groups/delete_user_group.dart';
import '../../api/groups/get_user_groups.dart';
import '../../authentication/amplify.dart';
import '../../utils.dart';
import '../group_screens/add_group/add_group_screen.dart';
import '../content/group.dart';
import '../group_screens/edit_group_screen/edit_group_screen.dart';
import '../group_screens/group_details_screen/group_details_screen.dart';
import '../loading_screen.dart';

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
              DefaultWidgets.buildHeader("Groups"),
              Expanded(child:
              !isLoaded ? LoadingScreen.getScreen() : buildGroupsScreen()
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
          elevation: 4,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EditGroupScreen(
                                userId: userId!,
                                groupId: userGroups[index].groupId,
                                groupName: userGroups[index].name,
                                groupDescription: userGroups[index].description,
                                status: userGroups[index].status)
                            ),
                          ).then(onGoBack);
                        },
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GroupDetailsScreen(
                      userId: userId!,
                      groupId: userGroups[index].groupId,
                      groupName: userGroups[index].name,
                      groupDescription: userGroups[index].description)
                  ),
                ).then(onGoBack);
              }
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