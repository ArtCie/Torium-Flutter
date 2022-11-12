import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../../utils.dart';

class AddEventScreen extends StatefulWidget {
  int groupId;
  AddEventScreen({super.key, required this.groupId});

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isBudget = false;

  String scheduleType = "Periodical";
  List<String> scheduleTypeOptions = [
    "Periodical",
    "Once"
  ];

  String schedulePeriod = "Weekly";
  List<String> schedulePeriodOptions = [
    "Daily",
    "Weekly",
    "Monthly"
  ];

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
      resizeToAvoidBottomInset : false,
      appBar: DefaultWidgets().buildAppBar(context: context, isProfile: false),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DefaultWidgets.buildHeader("Add event"),
              Expanded(
                  child: buildAddGroupWidget()
              ),
            ]
        ),
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
            buildDropdownWidget("Reminder type", scheduleTypeOptions, scheduleType),
            const SizedBox(height: 24),
            buildDropdownWidget("Schedule period", schedulePeriodOptions, schedulePeriod),
            const SizedBox(height: 48),
            buildContinueButton(),
          ],
        ),

      ),
    );
  }

  TextFormField buildTextFormField(String? name, TextEditingController controller) {
    return TextFormField(
        controller: controller,
        decoration: InputDecoration(
            labelText: name,
            contentPadding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
            border: const OutlineInputBorder(),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            filled: true,
            fillColor: Colors.white
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          if(controller == eventBudgetController){
            if(!isNumeric(value)){
              return 'Enter valid number!';
            }
          }
          return null;
        }
    );
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
        Expanded(child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
          child: Visibility(
              visible: isBudget,
              child: buildTextFormField("Budget", eventBudgetController)
          ),
        )),
      ],
    );
  }

  Widget buildDropdownWidget(String labelText, List<String> values, String currentValue) {
    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField2(
        decoration: InputDecoration(
            labelText: labelText,
            contentPadding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
            border: const OutlineInputBorder(),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            filled: true,
            fillColor: Colors.white
        ),
        hint: Text(
          'Select Item',
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).hintColor,
          ),
        ),
        items: values.map((item) =>
            DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            )).toList(),
        value: currentValue,
        onChanged: (value) {
          setState(() {
            currentValue = value as String;
          });
        },
      ),
    );
  }

  Widget buildContinueButton() {
    return SizedBox(
      height: 70.0,
      width: 250.0,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(backgroundColor: DefaultColors.getDefaultColor()),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => AddUsersToGroupScreen(userId: widget.userId,
            //       groupName: eventNameController.text, groupDescription: eventBudgetController.text)
            //   ),
            // )
            // TODO integrate
          }
        },
        child: const Text("Add members",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            )
        ),

      ),
    );
  }

}