import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../utils.dart';
import 'add_members_to_event.dart';

class AddEventScreen extends StatefulWidget {
  int groupId;
  String userId;

  AddEventScreen({super.key, required this.groupId, required this.userId});

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isBudget = false;

  String scheduleType = "Periodical";
  List<String> scheduleTypeOptions = ["Periodical", "Once"];

  String schedulePeriod = "Weekly";
  List<String> schedulePeriodOptions = ["Daily", "Weekly", "Monthly"];

  DateTime selectedDate = DateTime.now();
  bool isDateChosen = false;

  TextEditingController eventNameController = TextEditingController();
  TextEditingController eventDescriptionController = TextEditingController();
  TextEditingController eventBudgetController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: DefaultWidgets().buildAppBar(context: context, isProfile: false),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DefaultWidgets.buildHeader("Add event"),
              Expanded(child: buildAddGroupWidget()),
            ]),
      ),
    );
  }

  Widget buildAddGroupWidget() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            buildTextFormField("Event name", eventNameController),
            const SizedBox(height: 24),
            buildTextFormField("Event description", eventDescriptionController),
            const SizedBox(height: 24),
            buildCheckBoxWidget(),
            const SizedBox(height: 24),
            Row(
                children: [
                  buildDropdownWidget("Reminder type", scheduleTypeOptions, scheduleType),
                  const SizedBox(width: 12),
                  buildDropdownWidget("Schedule period", schedulePeriodOptions, schedulePeriod)
                ]
              ),
            const SizedBox(height: 24),
            buildDatePicker(),
            const SizedBox(height: 48),
            buildContinueButton(),
          ],
        ),
      ),
    );
  }

  TextFormField buildTextFormField(
      String? name, TextEditingController controller) {
    return TextFormField(
        controller: controller,
        decoration: InputDecoration(
            labelText: name,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
            border: const OutlineInputBorder(),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            filled: true,
            fillColor: Colors.white),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          if (controller == eventBudgetController) {
            if (!isNumeric(value)) {
              return 'Enter valid number!';
            }
          }
          return null;
        });
  }

  bool isNumeric(String s) {
    return double.tryParse(s) != null;
  }

  Widget buildCheckBoxWidget() {
    return Row(
      children: [
        Column(
          children: [
            const Text("Has \nbudget?"),
            Checkbox(
              shape: const CircleBorder(),
              checkColor: Colors.white,
              value: isBudget,
              onChanged: (bool? value) {
                setState(() {
                  isBudget = value!;
                });
              },
            ),
          ],
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
          child: Visibility(
              visible: isBudget,
              child: buildTextFormField("Budget", eventBudgetController)),
        )),
      ],
    );
  }

  Widget buildDropdownWidget(
      String labelText, List<String> values, String currentValue) {
    return Expanded(
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField2(
          decoration: InputDecoration(
              labelText: labelText,
              // contentPadding:
              //     const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
              border: const OutlineInputBorder(),
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
          value: currentValue,
          onChanged: (value) {
            setState(() {
              currentValue = value as String;
            });
          },
        ),
      ),
    );
  }

  ElevatedButton buildDatePicker() {
    return ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0.0,
              shadowColor: Colors.transparent,
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              shape: (
                  const RoundedRectangleBorder(
                    side: BorderSide(color: Colors.black),
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
                Text(isDateChosen == false ? "Select event datetime" : DateFormat('yyyy-MM-dd hh:mm').format(selectedDate)),
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
      selectedDate = dateTime;
      isDateChosen = true;
    });
  }

  Future<DateTime?> _selectDate(context) => showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
  
  Future<TimeOfDay?> pickTime(context) => showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: selectedDate.hour, minute: selectedDate.minute)
  );

  Widget buildContinueButton() {
    return SizedBox(
      height: 70.0,
      width: 250.0,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
            backgroundColor: DefaultColors.getDefaultColor()),
        onPressed: () {
          if (_formKey.currentState!.validate() && isDateChosen == true) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddMembersToEvent(
                      userId: widget.userId,
                      groupId: widget.groupId,
                      eventName: eventNameController.text,
                      eventDescription: eventDescriptionController.text,
                      hasBudget: isBudget,
                      budget: eventBudgetController.text,
                      reminderType: scheduleType,
                      schedulePeriod: schedulePeriod,
                      eventTimestamp: selectedDate),
            ));
          }
          if(isDateChosen == false){
            ScaffoldMessenger.of(context).showSnackBar(
                DefaultWidgets.getErrorSnackBarParam("Pick event datetime!"));
          }
        },
        child: const Text("Add members",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            )),
      ),
    );
  }
}
