
import 'package:flutter/material.dart';

import '../../../api/events/get_user_events.dart';
import '../../../utils.dart';
import '../../loading_screen.dart';
import 'event.dart';

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
    await GetUserEvents(widget.userId).fetch().then((result) async {
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
      appBar: DefaultWidgets().get(isProfile: false),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DefaultWidgets.buildHeader(widget.groupName, vertical: 15.0, alignment: Alignment.centerLeft),
              buildDescription(),
              buildMembersWidget(),
              DefaultWidgets.buildHeader("Events", vertical: 15.0, alignment: Alignment.centerLeft),
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
      padding: const EdgeInsets.fromLTRB(40, 0, 0, 20),
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
      child: ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 14.0),
          title: const Text("Group members"),
          trailing: const Icon(
              IconData(0xf8f5, fontFamily: 'MaterialIcons',
                  matchTextDirection: true)
          ),
          onTap: () {
          }
      ),
    );
  }

  Widget buildEvents() {
    return ListView.builder(
      itemCount: groupEvents.length,
      itemBuilder: (_, index) {
        return Card(
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