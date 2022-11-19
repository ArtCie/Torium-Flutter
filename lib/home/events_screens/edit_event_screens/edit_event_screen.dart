import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:torium/home/events_screens/edit_event_screens/edit_members_screen.dart';
import '../../../api/events/put_event.dart';
import '../../../utils.dart';
import '../../content/edit_group_param_screen.dart';
import '../../content/event_details.dart';
import 'package:string_extensions/string_extensions.dart';

import '../../content/member.dart';


class EditEventScreen extends StatefulWidget {
  String userId;
  EventDetails event;
  String userMail;

  EditEventScreen(
      {super.key,
      required this.userId,
        required this.userMail,
      required this.event});

  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  List<String> scheduleTypeOptions = ["Periodical", "Once"];
  List<String> schedulePeriodOptions = ["Daily", "Weekly", "Monthly"];
  Map<String, String> schedulePeriodMap = {
    "7 days, 0:00:00": "Weekly",
    "30 days, 0:00:00": "Monthly",
    "1 day, 0:00:00": "Daily",
  };
  Map<String, String> schedulePeriodReversedMap = {
    "Daily": "1 day, 0:00:00",
    "Weekly": "7 days, 0:00:00",
    "Monthly": "30 days, 0:00:00"
  };

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: DefaultWidgets().buildAppBar(context: context, isProfile: false),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              buildTitleRow(),
              DefaultWidgets.buildInfoHeader("Event name"),
              buildEditWidget(updateEventName,"Event name", widget.event.name),
              DefaultWidgets.buildInfoHeader("Event description"),
              buildEditWidget(updateEventDescription, "Event description", widget.event.description),
              buildMembersWidget(),
              Row(
                children: [
                  buildHasBudgetCheckbox(),
                  buildBudgetWidget()
                ]
              ),
              const SizedBox(height: 20),
              Row(
                  children: [
                    buildDropdownWidget("Reminder type", scheduleTypeOptions, updateReminder, widget.event.reminder.capitalize!),
                    const SizedBox(width: 12),
                    buildDropdownWidget("Schedule period", schedulePeriodOptions, updateSchedulePeriod, schedulePeriodMap[widget.event.schedulePeriod]!)
                  ]
              ),
              const SizedBox(height: 20),
              DefaultWidgets.buildInfoHeader("Event datetime"),
              buildDatePicker(),
        ]
      ),
    )
    );
  }

  Padding buildTitleRow() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 30, 20, 5),
        child:
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
                child: DefaultWidgets.buildHeader("Edit event",
                    bottom: 0.0, top: 0.0, alignment: Alignment.centerLeft)
            ),
            IconButton(icon: const Icon(Icons.check_rounded),
                constraints: const BoxConstraints(),
                onPressed: () {
                  PutEvent(widget.event.id, widget.userId, widget.event.isBudget, widget.event.budget,
                      widget.event.description, widget.event.datetime.toString(), widget.event.reminder.toLowerCase(),
                      widget.event.schedulePeriod, buildListUsers(widget.event.users), widget.event.name,
                      widget.event.groupId)
                      .fetch().then((result) {
                    if (result["status"]["code"] != 200) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(DefaultWidgets.getErrorSnackBar());
                      return;
                    }
                  });
                  Navigator.pop(context, widget.event);
                }),
          ],
        )
    );
  }

  List<int> buildListUsers(List<Member> users){
    List<int> result = [int.parse(widget.userId)];
    for(Member member in users){
      result.add(member.userId);
    }
    return result;
  }

  Expanded buildBudgetWidget() {
    return Expanded(
      child: Visibility(
        visible: widget.event.isBudget,
        child: Column(
          children: [
            DefaultWidgets.buildInfoHeader("Budget"),
            buildEditWidget(updateEventBudget, "Budget", widget.event.budget.toString(), vertical: 5.0, validType: "number"),
          ],
        )
      ),
    );
  }

  Column buildHasBudgetCheckbox() {
    return Column(
                  children: [
                    DefaultWidgets.buildInfoHeader("Has budget?"),
                    const SizedBox(height: 10.0),
                    Checkbox(
                      shape: const CircleBorder(),
                      checkColor: Colors.white,
                      value: widget.event.isBudget,
                      onChanged: (bool? value) {
                        setState(() {
                          widget.event.isBudget = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 15),
                  ],
                );
  }

  Card buildEditWidget(methodUpdate, fieldName, value, {double vertical = 10.0, validType = ""}) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: vertical, horizontal: 14.0),
          title: Text(value),
          trailing: const Icon(IconData(0xf8f5,
              fontFamily: 'MaterialIcons', matchTextDirection: true)),
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditParamScreen(
                      parameterName: fieldName,
                      parameterValue: value,
                      validType: validType)
              ),
            );
            if(result != null){
              methodUpdate(result);
            }
          }),
    );
  }

  Widget buildDropdownWidget(
      String labelText, List<String> values, dynamic updateFunction, String defaultValue) {
    return Expanded(
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField2(
          decoration: InputDecoration(
              labelText: labelText,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              filled: true,
              fillColor: Colors.white),
          hint: Text(
            'Select Item',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).hintColor,
            ),
          ),
          items: values
              .map((item) => DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ))
              .toList(),
          value: defaultValue,
          onChanged: (value) {
            setState(() {
              updateFunction(value as String);
            });
          },
        ),
      ),
    );
  }

  ElevatedButton buildDatePicker() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          elevation: 4,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          shape: (
              const RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(4.0))
              )
          )
      ),
      onPressed: () => _pickDateTime(context),
      child: Row(
          children: [
            const Icon(
                IconData(0xf06bb, fontFamily: 'MaterialIcons')
            ),
            const SizedBox(width: 10),
            Text(DateFormat('yyyy-MM-dd hh:mm').format(widget.event.datetime)),
            Spacer(),
            const Icon(Icons.arrow_drop_down)
          ]
      ),
    );
  }

  Future _pickDateTime(context) async{
    DateTime ? date = await _selectDate(context);
    if (date == null) return;

    TimeOfDay? time = await pickTime(context);
    if(time == null) return;

    final dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute
    );
    setState(() {
      widget.event.datetime = dateTime;
    });
  }

  Future<DateTime?> _selectDate(context) => showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101));

  Future<TimeOfDay?> pickTime(context) => showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: widget.event.datetime.hour, minute: widget.event.datetime.minute)
  );

  Card buildMembersWidget() {
    return Card(
      elevation: 4,  // Change this
      shadowColor: Colors.black12,  // Change this
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
          contentPadding:
          const EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
          title: Row(
            children: const [
              Icon(Icons.groups_rounded),
              SizedBox(width: 10),
              Text("Members"),
            ],
          ),
          trailing: const Icon(IconData(0xf8f5,
              fontFamily: 'MaterialIcons', matchTextDirection: true)),
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditMembersScreen(
                      userId: widget.userId,
                      userMail: widget.userMail,
                    groupId: widget.event.groupId,
                    alreadySubscribedUsers: widget.event.users)
              ),
            );
            if(result != null){
              widget.event.users = result;
            }
          }),
    );
  }

  updateEventName(value){
    widget.event.name = value;
  }

  updateEventDescription(value){
    widget.event.description = value;
  }

  updateEventBudget(value){
    widget.event.budget = value;
  }

  updateSchedulePeriod(value){
    widget.event.schedulePeriod = schedulePeriodReversedMap[value as String]!;
  }

  updateReminder(value){
    widget.event.reminder = "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
  }

}
