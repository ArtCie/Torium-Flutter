import 'package:flutter/material.dart';
import 'package:torium/api/events/get_all_events.dart';

import '../../../utils.dart';
import '../../authentication/amplify.dart';
import '../content/event_details.dart';
import '../loading_screen.dart';

class EventBaseScreen extends StatefulWidget {

  EventBaseScreen({super.key});

  @override
  _EventBaseScreenState createState() => _EventBaseScreenState();
}

class _EventBaseScreenState extends State<EventBaseScreen> {
  List<EventDetails> userEvents = [];
  String? userId;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    userId = (await AmplifyConfigure.getUserId())!;
    await GetAllEvents(userId!).fetch().then((result) async {
      setState(() {
        userEvents = [];
        for (var event in result["data"]) {
          print(event);
          userEvents.add(EventDetails(
              event["name"],
              event["description"],
              event["event_timestamp"],
              event["budget"],
              event["group_id"],
              event["group_name"],
              event["is_budget"],
              event["reminder"],
              event["schedule_period"],
              event["users"]));
        }
        isLoaded = true;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildHeaderWidget(),
              buildDescription(),
              buildInfoHeader("Group info"),
              buildMembersWidget(),
              buildInfoHeader("Events"),
              Expanded(
                  child: !isLoaded ? LoadingScreen.getScreen() : buildEvents()),
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
          DefaultWidgets.buildHeader("Events",
              vertical: 15.0, alignment: Alignment.centerLeft),
          buildAddIconButton()
        ],
      ),
    );
  }

  IconButton buildAddIconButton() {
    return IconButton(
      icon: const Icon(Icons.add_rounded, size: 35),
      onPressed: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => AddGroupMemberScreen(
        //           groupId: widget.groupId,
        //           userId: widget.userId,
        //           groupMembers: groupMembers
        //       )),
        // );
        setState(() {});
      },
    );
  }

  Padding buildDescription() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text("aaa",
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
      child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 14.0),
          title: const Text("Group members"),
          trailing: const Icon(IconData(0xf8f5,
              fontFamily: 'MaterialIcons', matchTextDirection: true)),
          onTap: () {
          }),
    );
  }

  onGoBack(dynamic value) {
    didChangeDependencies();
  }

  static Align buildInfoHeader(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 5),
        child: Text(text,
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey[500],
                fontWeight: FontWeight.w600,
                fontSize: 14)),
      ),
    );
  }

  Widget buildEvents() {
    return ListView.builder(
      itemCount: userEvents.length,
      itemBuilder: (_, index) {
        return Card(
          child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 14.0),
              title: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(userEvents[index].name),
              ),
              subtitle: Text(userEvents[index].description),
              trailing: Text(userEvents[index].datetime)),
          // onTap: () {
          // }
        );
      },
    );
  }
}
