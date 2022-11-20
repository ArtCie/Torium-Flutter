import 'package:flutter/material.dart';

import '../../../api/users/get_user_id_by_email.dart';
import '../../../api/groups/post_user_group.dart';
import '../../../api/groups_members/post_group_members.dart';
import '../../../utils.dart';
import '../../content/user.dart';

class AddUsersToGroupScreen extends StatefulWidget {
  String userId;
  String groupName;
  String groupDescription;
  AddUsersToGroupScreen({super.key, required this.userId, required this.groupName, required this.groupDescription});

  @override
  _AddUsersToGroupScreenState createState() => _AddUsersToGroupScreenState();
}

class _AddUsersToGroupScreenState extends State<AddUsersToGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController userEmailController = TextEditingController();
  List<User> usersToAdd = [];

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
      resizeToAvoidBottomInset : true,
      appBar: DefaultWidgets().buildAppBar(context: context, isProfile: false),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DefaultWidgets.buildHeader("Great, now invite users"),
              Expanded(
                  child: buildAddUsersToGroupWidget()
              ),
            ]
        ),
      ),
    );
  }

  Widget buildAddUsersToGroupWidget() {
      return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  buildTextFormField("User email", userEmailController),
                  const SizedBox(width: 10),
                  buildIconButton(),
                ],
              ),
              const SizedBox(height: 30),
              Expanded(
               child: buildUsersWidget()
              ),
              buildContinueButton(),
            ],
          ),

        ),
      );
    }

  IconButton buildIconButton() {
    return IconButton(
                  icon: const Icon(
                      IconData(0xe047, fontFamily: 'MaterialIcons'),
                      color: Color.fromRGBO(35, 54, 92, 0.6),
                  ),
                  tooltip: 'Add',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      checkIfUserExist(userEmailController.text);
                    }
                  },
                );
  }

  SizedBox buildTextFormField(String? name, TextEditingController controller) {
    return SizedBox(
      width: 335,
      child: TextFormField(
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
            return validEmailAddress(value);
          }
      ),
    );
  }

  String? validEmailAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    final bool emailValid =
    RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
    if(!emailValid){
      return 'Given email address is invalid!';
    }
    return null;
  }

 
  Widget buildContinueButton() {
    return SizedBox(
      height: 70.0,
      width: 250.0,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(backgroundColor: DefaultColors.getDefaultColor()),
        onPressed: () async {
          await insertGroupAndSendInvitations();

          int count = 0;
          if(!mounted) return;
          Navigator.popUntil(context, (route) {
            return count++ == 2;
          });
        },
        child: const Text("Done!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            )
        ),

      ),
    );
  }

  Future<void> checkIfUserExist(String email) async {

    if(usersToAdd.any((user) => user.email == email)){
      ScaffoldMessenger.of(context).showSnackBar(
          DefaultWidgets.getErrorSnackBarParam("You've already invited this user!")
      );
      return;
    }

    await GetUserIdByEmail(email).fetch().then((result) {
      if(result["status"]["code"] != 200){
        ScaffoldMessenger.of(context).showSnackBar(
            DefaultWidgets.getErrorSnackBarParam("User doesn't exist!")
        );
        return;
      }
      if(result["data"]["user_id"].toString() == widget.userId){
        ScaffoldMessenger.of(context).showSnackBar(
            DefaultWidgets.getErrorSnackBarParam("You want to invite yourself? ;-oo")
        );
        return;
      }
      setState(() {
        usersToAdd.insert(0, User(result["data"]["user_id"], email));
      });
    }
    );
  }

  Scrollbar buildUsersWidget() {
    return Scrollbar(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: usersToAdd.length,
        itemBuilder: (_, index) {
          return Card(
            elevation: 4,
            shadowColor: Colors.black12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 14.0),
                title: Text(usersToAdd[index].email),
                trailing:
                      IconButton(
                        icon: const Icon(
                            IconData(0xf645, fontFamily: 'MaterialIcons',
                                matchTextDirection: true),
                            color: Color.fromRGBO(35, 54, 92, 0.5)
                        ),
                        onPressed: () {
                          setState(() {
                            usersToAdd.removeAt(index);
                          });
                        },
                      )
                ),
            );
        },
      ),
    );
  }

  Future<void> insertGroupAndSendInvitations() async {
    PostUserGroup postUserGroup = PostUserGroup(widget.userId, widget.groupName, widget.groupDescription);
    await postUserGroup.fetch().then((result) {
      int groupId = result["data"]["group_id"];
      inviteUsersToGroup(groupId);
    });
  }

   inviteUsersToGroup(int groupId) {
    for(User user in usersToAdd){
      PostGroupMembers(user.userId, groupId).fetch().then((result) {
      });
    }
  }
}