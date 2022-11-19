import 'package:flutter/material.dart';
import 'package:torium/api/groups_members/get_group_members.dart';

import '../../../../api/groups_members/delete_group_member.dart';
import '../../../../api/groups_members/patch_user_group_role.dart';
import '../../../../utils.dart';
import '../../../loading_screen.dart';
import '../../../content/member.dart';
import 'add_group_member.dart';

class EditGroupMembersScreen extends StatefulWidget {
  String userId;
  int groupId;
  String userStatus;

  EditGroupMembersScreen(
      {super.key,
      required this.userId,
      required this.groupId,
      required this.userStatus});

  @override
  _EditGroupMembersScreenState createState() => _EditGroupMembersScreenState();
}

class _EditGroupMembersScreenState extends State<EditGroupMembersScreen> {
  List<Member> groupMembers = [];
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    await GetGroupMembers(widget.userId, widget.groupId.toString())
        .fetch()
        .then((result) async {
      setState(() {
        groupMembers = [];
        for (var event in result["data"]) {
          groupMembers
              .add(Member(event["user_id"], event["email"], event["status"]));
        }
        isLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: DefaultWidgets().buildAppBar(context: context, isProfile: false),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildHeaderWidget(),
              Expanded(
                  child:
                      !isLoaded ? LoadingScreen.getScreen() : buildMembers()),
            ]),
      ),
    );
  }

  Padding buildHeaderWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DefaultWidgets.buildHeader("Group Members",
              bottom: 15.0, alignment: Alignment.centerLeft),
          buildAddIconButton()
        ],
      ),
    );
  }

  IconButton buildAddIconButton() {
    return IconButton(
      icon: const Icon(Icons.add_rounded, size: 35),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddGroupMemberScreen(
                    groupId: widget.groupId,
                    userId: widget.userId,
                    groupMembers: groupMembers
                  )),
        );
        setState(() {});
      },
    );
  }

  Widget buildMembers() {
    return ListView.builder(
      itemCount: groupMembers.length,
      itemBuilder: (_, index) {
        return Card(
          elevation: 4,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 14.0),
              title: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(groupMembers[index].email),
              ),
              trailing: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(groupMembers[index].status),
                  getPopUpByStatus(index)
                ],
              )),
        );
      },
    );
  }

  Widget getPopUpByStatus(int index) {
    return Container(
      height: double.infinity,
      child: PopupMenuButton(
          icon: const Icon(
            IconData(0xf8dc, fontFamily: 'MaterialIcons'),
            size: 35,
          ),
          onSelected: (item) {
            handlePressedItem(item, index);
          },
          itemBuilder: (BuildContext context) =>
              getOptionsByStatus(groupMembers[index].status)),
    );
  }

  List<PopupMenuEntry<dynamic>> getOptionsByStatus(String status) {
    List<PopupMenuEntry<dynamic>> result = [];
    result
        .add(const PopupMenuItem(value: "delete", child: Text("Delete user")));
    if (status == 'standard') {
      result.add(const PopupMenuItem(
          value: "moderator", child: Text("Promote to moderator")));
      if (widget.userStatus == 'admin') {
        result.add(const PopupMenuItem(
            value: "admin", child: Text("Promote to admin")));
      }
    }
    if (status == 'moderator') {
      result.add(const PopupMenuItem(
          value: "standard", child: Text("Degrade to standard")));
      if (widget.userStatus == 'admin') {
        result.add(const PopupMenuItem(
            value: "admin", child: Text("Promote to admin")));
      }
    }
    if (status == 'admin' && widget.userStatus == 'admin') {
      result.add(const PopupMenuItem(
          value: "standard", child: Text("Degrade to standard")));
      result.add(const PopupMenuItem(
          value: "moderator", child: Text("Degrade to moderator")));
    }
    return result;
  }

  void handlePressedItem(String item, int index) {
    if (item == "delete") {
      DeleteGroupMember(groupMembers[index].userId, widget.groupId).fetch();
      setState(() {
        groupMembers.removeAt(index);
      });
    } else {
      PatchUserGroupRole(
              groupMembers[index].userId, widget.userId, widget.groupId, item)
          .fetch();
      setState(() {
        groupMembers[index].status = item;
      });
    }
  }
}
