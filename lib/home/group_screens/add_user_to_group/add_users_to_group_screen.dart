import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../api/users/get_user_id_by_email.dart';
import '../../../api/groups/post_user_group.dart';
import '../../../api/groups_members/post_group_members.dart';
import '../../../utils.dart';
import 'user.dart';

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
      appBar: DefaultWidgets().get(isProfile: false),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildHeader(),
              Expanded(
                  child: buildAddUsersToGroupWidget()
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
          "Great, now invite users",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.grey[800],
              fontWeight: FontWeight.bold,
              fontSize: 25)
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
                  SizedBox(width: 10),
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
                      IconData(0xe047, fontFamily: 'MaterialIcons')
                  ),
                  tooltip: 'Add',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      print("Email ${userEmailController.text}");
                      checkIfUserExist(userEmailController.text);
                    }
                    // setState(() {
                    //
                    // });
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
        style: OutlinedButton.styleFrom(backgroundColor: Colors.teal[300]),
        onPressed: () {
          insertGroupAndSendInvitations();

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
            child: ListTile(
              // leading: settingTypes[index].icon,
                contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 14.0),
                title: Text(usersToAdd[index].email),
                // subtitle: Text(settingTypes[index].value),
                trailing:
                      IconButton(
                        icon: const Icon(
                            IconData(0xf645, fontFamily: 'MaterialIcons',
                                matchTextDirection: true)
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

  void insertGroupAndSendInvitations() {
    // PostUserGroup postUserGroup = PostUserGroup(widget.userId, widget.groupName, widget.groupDescription);
    // await result = postUserGroup.fetch();

  }
}