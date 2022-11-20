import 'package:flutter/material.dart';
import 'package:torium/home/group_screens/edit_group_screen/edit_group_members/edit_group_members.dart';

import '../../../api/events/get_user_events.dart';
import '../../../api/groups/put_user_group.dart';
import '../../../utils.dart';
import '../../loading_screen.dart';
import '../../content/event.dart';
import '../../content/edit_group_param_screen.dart';

class EditGroupScreen extends StatefulWidget {
  String userId;
  int groupId;
  String groupName;
  String groupDescription;
  String status;

  EditGroupScreen(
      {super.key,
      required this.userId,
      required this.groupId,
      required this.groupName,
      required this.groupDescription,
      required this.status});

  @override
  _EditGroupScreenState createState() => _EditGroupScreenState();
}

class _EditGroupScreenState extends State<EditGroupScreen> {
  String groupName = "";
  String groupDescription = "";
  List<Event> groupEvents = [];
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    await GetUserEvents(widget.userId, widget.groupId.toString())
        .fetch()
        .then((result) async {
      setState(() {
        groupEvents = [];
        for (var event in result["data"]) {
          groupEvents.add(Event(
              event["name"], event["description"], event["event_timestamp"]));
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
              DefaultWidgets.buildInfoHeader("Group name"),
              buildGroupWidget(),
              DefaultWidgets.buildInfoHeader("Group description"),
              buildDescriptionWidget(),
              DefaultWidgets.buildInfoHeader("Group info"),
              buildMembersWidget(),
              DefaultWidgets.buildInfoHeader("Events"),
              Expanded(
                  child: !isLoaded ? LoadingScreen.getScreen() : buildEvents()),
            ]),
      ),
    );
  }

  Padding buildDescription() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(widget.groupDescription,
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.normal,
                fontSize: 13)),
      ),
    );
  }

  Card buildMembersWidget() {
    return Card(
      elevation: 4,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 14.0),
          title: const Text("Group members"),
          trailing: const Icon(IconData(0xf8f5,
              fontFamily: 'MaterialIcons', matchTextDirection: true),
              color: Color.fromRGBO(35, 54, 92, 0.5)),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditGroupMembersScreen(
                      userId: widget.userId,
                      groupId: widget.groupId,
                      userStatus: widget.status)),
            );
          }),
    );
  }

  Card buildGroupWidget() {
    return Card(
      elevation: 4,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 14.0),
          title: Text(groupName == null || groupName.isEmpty
              ? widget.groupName
              : groupName),
          trailing: const Icon(IconData(0xf8f5,
              fontFamily: 'MaterialIcons', matchTextDirection: true),
              color: Color.fromRGBO(35, 54, 92, 0.5)),
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditParamScreen(
                      parameterName: "Group name",
                      parameterValue: groupName == null || groupName.isEmpty
                          ? widget.groupName
                          : groupName)),
            );
            if (result != null) {
              await PutUserGroup(
                      widget.groupId,
                      widget.userId,
                      result,
                      groupDescription == null || groupDescription.isEmpty
                          ? widget.groupDescription
                          : groupDescription)
                  .fetch();
              setState(() {
                groupName = result;
              });
            }
          }),
    );
  }

  Card buildDescriptionWidget() {
    return Card(
      elevation: 4,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 14.0),
          title: Text(groupDescription == null || groupDescription.isEmpty
              ? widget.groupDescription
              : groupDescription),
          trailing: const Icon(IconData(0xf8f5,
              fontFamily: 'MaterialIcons', matchTextDirection: true),
              color: Color.fromRGBO(35, 54, 92, 0.5)),
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditParamScreen(
                      parameterName: "Group description",
                      parameterValue:
                          groupDescription == null || groupDescription.isEmpty
                              ? widget.groupDescription
                              : groupDescription)),
            );
            if (result != null) {
              await PutUserGroup(
                      widget.groupId,
                      widget.userId,
                      groupName == null || groupName.isEmpty
                          ? widget.groupName
                          : groupName,
                      result)
                  .fetch();
              setState(() {
                groupDescription = result;
              });
            }
          }),
    );
  }

  onGoBack(dynamic value) {
    didChangeDependencies();
  }

  Widget buildEvents() {
    return ListView.builder(
      itemCount: groupEvents.length,
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
                child: Text(groupEvents[index].name),
              ),
              subtitle: Text(groupEvents[index].description),
              trailing: Text(groupEvents[index].datetime)),
          // onTap: () {
          // }
        );
      },
    );
  }
}
