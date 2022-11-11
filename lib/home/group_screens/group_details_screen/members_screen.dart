
import 'package:flutter/material.dart';
import 'package:torium/api/groups_members/get_group_members.dart';

import '../../../utils.dart';
import '../../loading_screen.dart';
import '../member.dart';

class MembersScreen extends StatefulWidget {
  String userId;
  int groupId;
  MembersScreen({super.key, required this.userId, required this.groupId});

  @override
  _MembersScreenState createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  List<Member> groupMembers = [];
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    await GetGroupMembers(widget.userId, widget.groupId.toString()).fetch().then((result) async {
      setState(() {
        groupMembers = [];
        for (var event in result["data"]) {
          groupMembers.add(Member(event["user_id"],
              event["email"], event["status"]));
        }
        isLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : true,
      appBar: DefaultWidgets().get(isProfile: false),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DefaultWidgets.buildHeader("Group Members", vertical: 15.0, alignment: Alignment.centerLeft),
              Expanded(
                  child: !isLoaded ? LoadingScreen.getScreen() : buildMembers()
              ),
            ]
        ),
      ),
    );
  }

  Widget buildMembers() {
    return ListView.builder(
      itemCount: groupMembers.length,
      itemBuilder: (_, index) {
        return Card(
          child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 14.0),
              title: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(groupMembers[index].email),
              ),
              trailing: Text(groupMembers[index].status)
          ),
          // onTap: () {
          // }
        );
      },
    );
  }
}