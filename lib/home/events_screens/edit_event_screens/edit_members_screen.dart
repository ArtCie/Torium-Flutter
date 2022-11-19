
import 'package:flutter/material.dart';
import 'package:torium/home/events_screens/add_event/member_overload.dart';

import '../../../api/groups_members/get_group_members.dart';
import '../../../utils.dart';
import '../../content/member.dart';
import '../../loading_screen.dart';
import 'package:collection/collection.dart';


class EditMembersScreen extends StatefulWidget {
  int groupId;
  String userId;
  String userMail;
  List<Member> alreadySubscribedUsers;
  EditMembersScreen({super.key, required this.userId, required this.groupId, required this.userMail, required this.alreadySubscribedUsers});

  @override
  _EditMembersScreenState createState() => _EditMembersScreenState();
}

class _EditMembersScreenState extends State<EditMembersScreen> {
  List<MemberOverload> groupMembers = [];
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    await GetGroupMembers(widget.userId, widget.groupId.toString()).fetch().then((result) async {
      setState(() {
        groupMembers = [];
        for (var event in result["data"]) {
          groupMembers.add(MemberOverload(event["user_id"],
              event["email"],
              event["status"],
              isChosen: widget.alreadySubscribedUsers.firstWhereOrNull((a) => a.userId == event["user_id"]) != null)
          );
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
              DefaultWidgets.buildHeader("Add members to event"),
              Expanded(child:
              !isLoaded ? LoadingScreen.getScreen() :
              Column(
                children: [
                  buildMembers(),
                  const SizedBox(height: 20),
                  buildContinueButton()
                ],
              )
              )
            ]
        ),
      ),
    );
  }

  Widget buildMembers() {
    return ListView.builder(
      itemCount: groupMembers.length,
      shrinkWrap: true,
      itemBuilder: (_, index) {
        return Card(
          elevation: 4,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 14.0),
              title: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(groupMembers[index].email),
              ),
              trailing: Transform.scale(
                scale: 1.3,
                child: Checkbox(
                  shape: const CircleBorder(),
                  checkColor: Colors.white,
                  value: groupMembers[index].isChosen,
                  onChanged: (bool? value) {
                    setState(() {
                      groupMembers[index].isChosen = value!;
                    });
                  },
                ),
              )
          ),
          // onTap: () {
          // }
        );
      },
    );
  }


  Widget buildContinueButton() {
    return SizedBox(
      height: 70.0,
      width: 250.0,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(backgroundColor: DefaultColors.getDefaultColor()),
        onPressed: () async {
          collectDataAndSaveEvent().then((result) {
            Navigator.pop(context, result);
          });
        },
        child: const Text("Save",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            )
        ),

      ),
    );
  }

  Future<List<Member>> collectDataAndSaveEvent() async {
    List<Member> chosenMembers = [Member(int.parse(widget.userId), widget.userMail, 'moderator')];
    for(MemberOverload member in groupMembers){
      if(member.isChosen == true){
        chosenMembers.add(Member(member.userId, member.email, member.status));
      }
    }
    return chosenMembers;
  }

}