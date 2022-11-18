
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:torium/home/events_screens/add_event/member_overload.dart';

import '../../../api/events/post_event.dart';
import '../../../api/groups_members/get_group_members.dart';
import '../../../utils.dart';
import '../../loading_screen.dart';


class AddMembersToEvent extends StatefulWidget {
  Map<String, String> schedulePeriodMap = {
    "Daily": "1 day",
    "Weekly": "1 week",
    "Monthly": "1 month"
  };
  int groupId;
  String userId;
  String eventName;
  String eventDescription;
  bool hasBudget;
  dynamic budget;
  String reminderType;
  String schedulePeriod;
  DateTime eventTimestamp;
  AddMembersToEvent({super.key, required this.userId, required this.groupId,
                      required this.eventName, required this.eventDescription,
                      required this.hasBudget, required this.budget,
                      required this.reminderType, required this.schedulePeriod,
                      required this.eventTimestamp});

  @override
  _AddMembersToEventState createState() => _AddMembersToEventState();
}

class _AddMembersToEventState extends State<AddMembersToEvent> {
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
              event["email"], event["status"]));
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
          await collectDataAndSaveEvent();
          if(!mounted) return;
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
        child: const Text("Submit event!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            )
        ),

      ),
    );
  }

  Future<void> collectDataAndSaveEvent() async {
    List<int> chosenMembers = [int.parse(widget.userId)];
    for(MemberOverload member in groupMembers){
      if(member.isChosen == true){
        chosenMembers.add(member.userId);
      }
    }
    await PostEvent(widget.groupId,
        widget.hasBudget,
        widget.budget,
        widget.eventDescription,
        '${DateFormat('yyyy-MM-dd kk:mm:ss').format(widget.eventTimestamp)}.00',
        widget.reminderType.toLowerCase(),
        widget.schedulePeriodMap[widget.schedulePeriod],
        chosenMembers,
        widget.eventName).fetch();
  }

}