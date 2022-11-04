import 'package:flutter/material.dart';
import '../add_user_to_group/add_users_to_group_screen.dart';
import '../add_user_to_group/add_users_to_group_screen.dart';

import '../../../utils.dart';

class AddGroupScreen extends StatefulWidget {
  String userId;
  AddGroupScreen({super.key, required this.userId});

  @override
  _AddGroupScreenState createState() => _AddGroupScreenState();
}

class _AddGroupScreenState extends State<AddGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController groupNameController = TextEditingController();
  TextEditingController groupDescriptionController = TextEditingController();

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
      appBar: DefaultWidgets().get(isProfile: false),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildHeader(),
              Expanded(
                  child: buildAddGroupWidget()
              ),
            ]
        ),
      ),
    );
  }

  Padding buildHeader() {
    return Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 30.0, horizontal: 40.0),
              child: Text(
                  "Add group",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 25)
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
            buildTextFormField("Group name", groupNameController),
            const SizedBox(height: 35),
            buildTextFormField("Group description", groupDescriptionController),
            const SizedBox(height: 70),
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
                return null;
              }
          );
  }

  Widget buildContinueButton() {
    return SizedBox(
      height: 70.0,
      width: 250.0,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(backgroundColor: Colors.teal[300]),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            print(widget.userId);
            print(groupNameController.text);
            print(groupDescriptionController.text);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddUsersToGroupScreen(userId: widget.userId,
                  groupName: groupNameController.text, groupDescription: groupDescriptionController.text)
              ),
            );
          }
        },
        child: const Text("Continue to invite users",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            )
        ),

      ),
    );
  }
}