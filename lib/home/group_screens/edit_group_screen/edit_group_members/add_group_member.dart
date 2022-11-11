import 'package:flutter/material.dart';
import '../../../../api/groups_members/post_group_members.dart';
import '../../../../api/users/get_user_id_by_email.dart';
import '../../../../utils.dart';
import '../../member.dart';

class AddGroupMemberScreen extends StatefulWidget {
  int groupId;
  String userId;
  List<Member> groupMembers;

  AddGroupMemberScreen(
      {super.key,
      required this.groupId,
      required this.userId,
      required this.groupMembers});

  @override
  _AddGroupMemberScreenState createState() => _AddGroupMemberScreenState();
}

class _AddGroupMemberScreenState extends State<AddGroupMemberScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController userEmailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: DefaultWidgets().get(isProfile: false),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildHeaderWidget(),
              Expanded(child: buildAddUserToGroupWidget())
            ]),
      ),
    );
  }

  Padding buildHeaderWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
      child: DefaultWidgets.buildHeader("Add Member",
          vertical: 15.0, alignment: Alignment.centerLeft),
    );
  }

  Widget buildAddUserToGroupWidget() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            buildTextFormField("User email", userEmailController),
            const SizedBox(height: 30),
            buildContinueButton(),
          ],
        ),
      ),
    );
  }

  SizedBox buildTextFormField(String? name, TextEditingController controller) {
    return SizedBox(
      child: TextFormField(
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
            return validEmailAddress(value);
          }),
    );
  }

  String? validEmailAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    final bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
    if (!emailValid) {
      return 'Given email address is invalid!';
    }
    return null;
  }

  Widget buildContinueButton() {
    return SizedBox(
      height: 70.0,
      width: 250.0,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(backgroundColor: Colors.teal[300]),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            checkIfUserExist(userEmailController.text);
          }
        },
        child: const Text("Invite",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            )),
      ),
    );
  }

  Future<void> checkIfUserExist(String email) async {
    await GetUserIdByEmail(email).fetch().then((result) {
      if (result["status"]["code"] != 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            DefaultWidgets.getErrorSnackBarParam("User doesn't exist!"));
        return;
      }
      if (result["data"]["user_id"].toString() == widget.userId) {
        ScaffoldMessenger.of(context).showSnackBar(
            DefaultWidgets.getErrorSnackBarParam(
                "You want to invite yourself? ;-oo"));
        return;
      }
      if (checkIfUserAlreadyInGroup(email)) {
        ScaffoldMessenger.of(context).showSnackBar(
            DefaultWidgets.getErrorSnackBarParam("User already in group!"));
        return;
      }
      PostGroupMembers(result["data"]["user_id"], widget.groupId)
          .fetch()
          .then((result) async {
        await handlePostInviteAction(result);
      });
    });
  }

  bool checkIfUserAlreadyInGroup(String email) {
    for (Member member in widget.groupMembers) {
      if (member.email == email) {
        return true;
      }
    }
    return false;
  }

  Future<void> handlePostInviteAction(Map<dynamic, dynamic> result) async {
    if (result["status"]["code"] != 200) {
      ScaffoldMessenger.of(context).showSnackBar(
          DefaultWidgets.getErrorSnackBarParam("User already invited!"));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
        DefaultWidgets.getErrorSnackBarParam("Successfully invited user ;)")
    );
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    Navigator.pop(context);
    return;
  }
}
