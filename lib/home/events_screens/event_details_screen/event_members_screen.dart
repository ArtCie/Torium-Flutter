
import 'package:flutter/material.dart';

import '../../../utils.dart';
import '../../content/member.dart';

class EventMembersScreen extends StatefulWidget {
  List<dynamic> eventMembers;
  EventMembersScreen({super.key, required this.eventMembers});

  @override
  _EventMembersScreenState createState() => _EventMembersScreenState();
}

class _EventMembersScreenState extends State<EventMembersScreen> {

  @override
  void initState() {
    super.initState();
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
              DefaultWidgets.buildHeader("Event Members", vertical: 15.0, alignment: Alignment.centerLeft),
              Expanded(
                  child: buildMembers()
              ),
            ]
        ),
      ),
    );
  }

  Widget buildMembers() {
    return ListView.builder(
      itemCount: widget.eventMembers.length,
      itemBuilder: (_, index) {
        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 14.0),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(widget.eventMembers[index].email),
            ),
          ),
          // onTap: () {
          // }
        );
      },
    );
  }
}