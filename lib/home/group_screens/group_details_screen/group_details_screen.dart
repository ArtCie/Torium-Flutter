
import 'package:flutter/material.dart';

import '../../../api/events/get_user_events.dart';
import '../../../utils.dart';
import '../../loading_screen.dart';
import '../../content/event.dart';
import 'members_screen.dart';

class GroupDetailsScreen extends StatefulWidget {
  String userId;
  int groupId;
  String groupName;
  String groupDescription;
  GroupDetailsScreen({super.key, required this.userId, required this.groupId,
    required this.groupName, required this.groupDescription});

  @override
  _GroupDetailsScreenState createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  List<Event> groupEvents = [];
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    await GetUserEvents(widget.userId, widget.groupId.toString()).fetch().then((result) async {
      setState(() {
        groupEvents = [];
        for (var event in result["data"]) {
          groupEvents.add(Event(event["name"],
              event["description"], event["event_timestamp"]));
        }
        isLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : true,
      appBar: DefaultWidgets().buildAppBar(context: context, isProfile: false),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DefaultWidgets.buildHeader(widget.groupName, bottom: 15.0, alignment: Alignment.centerLeft),
              buildDescription(),
              DefaultWidgets.buildInfoHeader("Group info"),
              buildMembersWidget(),
              DefaultWidgets.buildInfoHeader("Events"),
              Expanded(
                  child: !isLoaded ? LoadingScreen.getScreen() : buildEvents()
              ),
            ]
        ),
      ),
    );
  }

  Padding buildDescription(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
            widget.groupDescription,
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.normal,
                fontSize: 13)
        ),
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
          contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 14.0),
          title: const Text("Group members"),
          trailing: const Icon(
              IconData(0xf8f5, fontFamily: 'MaterialIcons',
                  matchTextDirection: true)
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MembersScreen(
                  userId: widget.userId,
                  groupId: widget.groupId
              )
              ),
            ).then(onGoBack);
          }
      ),
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
              contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 14.0),
              title: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(groupEvents[index].name),
              ),
              subtitle: Text(groupEvents[index].description),
              trailing: Text(groupEvents[index].datetime)
          ),
          // onTap: () {
          // }
        );
      },
    );
  }
}