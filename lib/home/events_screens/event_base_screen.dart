import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  Map<String, String> schedulePeriodMap = {
    "7 days, 0:00:00": "Weekly",
    "30 days, 0:00:00": "Monthly",
    "1 day, 0:00:00": "Daily",
  };
  DateTime currentTimestamp = DateTime.now();
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
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildHeaderWidget(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                    children: [
                      DefaultWidgets.buildHeader("Upcoming", fontSize: 16, vertical: 15.0, alignment: Alignment.centerLeft),
                      getEventsScreen(getEventsFiltered(const Duration(days: 7))),
                      DefaultWidgets.buildHeader("This month", fontSize: 16, vertical: 15.0, alignment: Alignment.centerLeft),
                      getEventsScreen(getMonthlyEvents()),
                      DefaultWidgets.buildHeader("Later", fontSize: 16, vertical: 15.0, alignment: Alignment.centerLeft),
                      getEventsScreen(getLaterEvents()),
                    ]
                  ),
                ),
              )
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

  onGoBack(dynamic value) {
    didChangeDependencies();
  }

  Widget buildEvents(List<EventDetails> events) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: events.length,
      itemBuilder: (_, index) {
        return Card(
          child:
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 14.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildUpperCard(events, index),
                  const SizedBox(height: 10),
                  buildLowerCard(events, index)
                ]
              ),
            )
          // onTap: () {
          // }
        );
      },
    );
  }

  Row buildLowerCard(List<EventDetails> events, int index) {
    return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DateFormat('dd MMM yyyy').format(events[index].datetime)),
                    const Text('.'),
                    Text(events[index].groupName),
                    const Text('.'),
                    Text(schedulePeriodMap[events[index].schedulePeriod]!),
                  ]
                );
  }

  Row buildUpperCard(List<EventDetails> events, int index) {
    return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(events[index].name),
                    events[index].isBudget ? Text("${events[index].budget} PLN") : const Text("")
                  ]
                );
  }

  getEventsScreen(List<EventDetails> eventsFiltered) {
    return !isLoaded ? LoadingScreen.getScreen() : buildEvents(eventsFiltered);
  }

  List<EventDetails> getEventsFiltered(Duration duration){
    return userEvents.where((event) => event.datetime.compareTo(currentTimestamp.add(duration)) < 0).toList();
  }

  List<EventDetails> getMonthlyEvents() {
    List<EventDetails> weeklyEvents = getEventsFiltered(const Duration(days: 7));
    List<EventDetails> monthlyEvents = getEventsFiltered(const Duration(days: 31));
    monthlyEvents.removeWhere((element) => weeklyEvents.contains(element));
    return monthlyEvents;
  }

  List<EventDetails> getLaterEvents() {
    List<EventDetails> copyEventDetails = List.from(userEvents);
    List<EventDetails> monthlyEvents = getEventsFiltered(const Duration(days: 31));
    copyEventDetails.removeWhere((element) => monthlyEvents.contains(element));
    return copyEventDetails;
  }
}
