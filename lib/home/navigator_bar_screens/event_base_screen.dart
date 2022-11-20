import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:torium/api/events/get_all_events.dart';

import '../../../utils.dart';
import '../../authentication/amplify.dart';
import '../content/event_details.dart';
import '../content/member.dart';
import '../events_screens/add_event/choose_group_screen.dart';
import '../events_screens/event_details_screen/event_details_screen.dart';
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
              event["id"],
              event["name"],
              event["description"],
              event["event_timestamp"],
              event["is_budget"] ? event["budget"]: -1,
              event["group_id"],
              event["group_name"],
              event["is_budget"],
              event["reminder"],
              event["schedule_period"],
              event["status"],
              parseMembers(event["users"])));
        }
        isLoaded = true;
      });
    });
    super.didChangeDependencies();
  }

  List<Member> parseMembers(users){
    List<Member> result = [];
    for (Map user in users) {
        result.add(Member(user["id"], user["email"], ""));
    }
    return result;
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
                      DefaultWidgets.buildHeader("Upcoming", fontSize: 16, bottom: 15.0, alignment: Alignment.centerLeft),
                      getEventsScreen(getEventsFiltered(const Duration(days: 7))),
                      DefaultWidgets.buildHeader("This month", fontSize: 16, bottom: 15.0, alignment: Alignment.centerLeft),
                      getEventsScreen(getMonthlyEvents()),
                      DefaultWidgets.buildHeader("Later", fontSize: 16, bottom: 15.0, alignment: Alignment.centerLeft),
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
              bottom: 15.0, alignment: Alignment.centerLeft),
          buildAddIconButton()
        ],
      ),
    );
  }

  IconButton buildAddIconButton() {
    return IconButton(
      icon: const Icon(Icons.add_rounded, size: 35),
      color: const Color.fromRGBO(35, 54, 92, 0.5),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChooseGroupScreen(userId: userId!)),
        ).then(onGoBack);
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
        return GestureDetector(
          child: Card(
            elevation: 4,
            shadowColor: Colors.black12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 14.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildUpperCard(events, index),
                    const SizedBox(height: 10),
                    buildLowerCard(events, index)
                  ],
                ),
              ),
          ),
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EventDetailsScreen(userId: userId!, event: events[index])),
            );
            if(result == 'delete'){
              events.removeAt(index);
            }
            onGoBack(result);
          }
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
    return !isLoaded ? getLoadingScreen() : buildEvents(eventsFiltered);
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

  Center getLoadingScreen() {
      return Center(
          child: SpinKitCubeGrid(
              color: DefaultColors.getDefaultColor(),
              size: 60
          )
      );
  }
}
