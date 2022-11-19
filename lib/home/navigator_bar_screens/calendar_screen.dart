import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:torium/api/events/get_all_events.dart';

import '../../../utils.dart';
import '../../authentication/amplify.dart';
import '../content/event_details.dart';
import '../content/member.dart';
import '../events_screens/event_details_screen/event_details_screen.dart';

class CalendarScreen extends StatefulWidget {

  CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  Map<DateTime, List<dynamic>> _events = {};
  List<dynamic> _selectedEvents = [];
  CalendarController _controller = CalendarController();
  Map<String, String> schedulePeriodMap = {
    "7 days, 0:00:00": "Weekly",
    "30 days, 0:00:00": "Monthly",
    "1 day, 0:00:00": "Daily",
  };
  DateTime currentTimestamp = DateTime.now();
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
        _events = {};
        for (var event in result["data"]) {
          DateTime dt = DateTime.parse(event['event_timestamp']);
          DateTime formattedDt = DateTime(dt.year, dt.month, dt.day);
          if(_events[formattedDt] == null){
            _events[formattedDt] = [];
          }
          _events[formattedDt]?.add(EventDetails(
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
                        buildTableCalendar(),
                        SizedBox(height: 20),
                        ...buildSelectedEvents(context),
                      ],
                  ),
                ),
              )]
                  ),
                ),
              );
  }

  TableCalendar buildTableCalendar() {
    return TableCalendar(
                        events: _events,
                        initialCalendarFormat: CalendarFormat.month,
                        headerStyle: const HeaderStyle(
                          formatButtonVisible: false,
                          centerHeaderTitle: true
                        ),
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        onDaySelected: (date, events,holidays) {
                          setState(() {
                            _selectedEvents = events;
                          });
                        },
                        builders: CalendarBuilders(
                          selectedDayBuilder: (context, date, events) => Container(
                              margin: const EdgeInsets.all(4.0),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Text(
                                date.day.toString(),
                                style: const TextStyle(color: Colors.white),
                              )),
                          todayDayBuilder: (context, date, events) => Container(
                              margin: const EdgeInsets.all(4.0),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Text(
                                date.day.toString(),
                                style: const TextStyle(color: Colors.white),
                              )),
                        ),
                        calendarController: _controller,
                      );
  }

  Iterable<Widget> buildSelectedEvents(BuildContext context) {
    return _selectedEvents.map((event) => GestureDetector(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 14.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildUpperCard(event),
                const SizedBox(height: 10),
                buildLowerCard(event)
              ],
            ),
          ),
        ),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EventDetailsScreen(userId: userId!, event: event)),
          );
        }
    ));
  }

  Row buildLowerCard(EventDetails event) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(DateFormat('dd MMM yyyy').format(event.datetime)),
          const Text('.'),
          Text(event.groupName),
          const Text('.'),
          Text(schedulePeriodMap[event.schedulePeriod]!),
        ]
    );
  }

  Row buildUpperCard(EventDetails event) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(event.name),
          event.isBudget ? Text("${event.budget} PLN") : const Text("")
        ]
    );
  }


  Padding buildHeaderWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 30, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DefaultWidgets.buildHeader("Event calendar",
              bottom: 15.0, alignment: Alignment.centerLeft)
        ],
      ),
    );
  }


}
