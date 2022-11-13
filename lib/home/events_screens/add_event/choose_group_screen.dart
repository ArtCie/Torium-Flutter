import 'dart:io';

import 'package:flutter/material.dart';
import 'package:torium/home/events_screens/add_event/add_event_screen.dart';

import '../../../api/groups/get_user_groups.dart';
import '../../../utils.dart';
import '../../content/group.dart';
import '../../loading_screen.dart';

class ChooseGroupScreen extends StatefulWidget {
  String userId;
  ChooseGroupScreen({super.key, required this.userId});

  @override
  _ChooseGroupScreenState createState() => _ChooseGroupScreenState();
}

class _ChooseGroupScreenState extends State<ChooseGroupScreen> {
  List<Group> userGroups = [];
  bool isLoaded = false;
  int _indexChosen = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    await GetUserGroups(widget.userId).fetch().then((result) async {
      setState(() {
        userGroups = [];
        for (var group in result["data"]) {
          if(group["status"] != "standard") {
            userGroups.add(Group(
                group["admin_id"], group["group_id"],
                group["name"], group["description"], group["status"]));
          }
        }
        isLoaded = true;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: DefaultWidgets().buildAppBar(context: context, isProfile: false),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildHeader("To which group?"),
              Expanded(
                  child: !isLoaded ? LoadingScreen.getScreen() : userGroups.isEmpty ? loadEmptyListScreen() :
                  Column(
                    children: [
                      buildGroupsWidget(),
                      const SizedBox(height: 20),
                      buildContinueButton()
                    ]
                  )
              ),
            ]
        ),
      ),
    );
  }

  Widget loadEmptyListScreen() {
    sleepAndGoBack();
    return buildHeader("To add event \nyou need to \ncreate a group \nor be moderator/admin\n of one");
  }

  Future<void> sleepAndGoBack() async {
    await Future.delayed(const Duration(seconds: 4));
    if(!mounted) return;
    Navigator.pop(context);
  }

  Padding buildHeader(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 30.0, horizontal: 40.0),
      child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.grey[800],
              fontWeight: FontWeight.bold,
              fontSize: 25)
      ),
    );
  }

  Widget buildGroupsWidget() {
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: userGroups.length,
        itemBuilder: (_, index) {
          return Card(
            child: ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 14.0),
                title: Text(userGroups[index].name),
                trailing: getTrailingIcon(index),
                onTap: () {
                  setState(() {
                    _indexChosen = index;
                  });
                }
            ),
          );
        },
      );
  }

  Icon getTrailingIcon(int index) {
    return _indexChosen == index ? Icon(
                  const IconData(0xf635, fontFamily: 'MaterialIcons',
                      matchTextDirection: true),
                    color: DefaultColors.getDefaultColor(),
              ) : const Icon(
                  IconData(0xef53, fontFamily: 'MaterialIcons',
                      matchTextDirection: true)
              );
  }

  Widget buildContinueButton() {
    return SizedBox(
      height: 70.0,
      width: 250.0,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(backgroundColor: DefaultColors.getDefaultColor(opacity: _indexChosen == -1 ? 0.1 : 0.9)),
        onPressed: _indexChosen == -1 ? null: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEventScreen(groupId: userGroups[_indexChosen].groupId, userId: widget.userId)),
          );
        },
        child: const Text("Continue",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            )
        ),

      ),
    );
  }
}