import 'package:flutter/material.dart';

import '../../../api/groups_members/patch_status_group_members.dart';
import '../../../api/groups/invitations/get_invitations.dart';
import 'notification.dart';
import '../../../authentication/amplify.dart';
import '../../../utils.dart';
import '../../loading_screen.dart';

class NotificationScreen extends StatefulWidget{
  const NotificationScreen({Key? key}) : super(key: key);

  State<NotificationScreen> createState() => _NotificationsState();
}

class _NotificationsState extends State<NotificationScreen>{
  String? userId;
  bool isLoaded = false;
  List<UserNotification> userNotifications = [];

  void initState() {
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    userId = (await AmplifyConfigure.getUserId())!;
    await GetInvitations(userId!).fetch().then((result) async {
      setState(() {
        userNotifications = [];
        for (var notification in result["data"]) {
          userNotifications.add(UserNotification(
              notification["email"], notification["group_id"], notification["name"]));
        }
        isLoaded = true;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DefaultWidgets.buildHeader("Notifications", alignment: Alignment.centerLeft),
              Expanded(child:
              isLoaded == false ? LoadingScreen.getScreen() : buildNotificationScreen()
              ),
            ]
        ),
      ),
    );
  }

  onGoBack(dynamic value) {
    didChangeDependencies();
  }

  Widget buildNotificationScreen() {
    return userNotifications.isEmpty ? DefaultWidgets.buildHeader("All good for now") : ListView.builder(
      itemCount: userNotifications.length,
      itemBuilder: (_, index) {
        return Card(
          elevation: 4,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 14.0),
              title: Text(userNotifications[index].name),
              subtitle: Text('Invited by ${userNotifications[index].email}'),
              trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget> [
                    IconButton(
                      icon: const Icon(
                          IconData(0xf636, fontFamily: 'MaterialIcons',
                              matchTextDirection: true),
                        color: Colors.green
                      ),
                      onPressed: () {
                        sendAnswer('confirmed', userNotifications[index].groupId);
                        setState(() {
                          userNotifications.removeAt(index);
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                          IconData(0xf645, fontFamily: 'MaterialIcons',
                          matchTextDirection: true),
                        color: Colors.red
                      ),
                      onPressed: () {
                        sendAnswer('rejected', userNotifications[index].groupId);
                        setState(() {
                          userNotifications.removeAt(index);
                        });
                      },
                    )
                  ]
              ),
              onTap: null
          ),
        );
      },
    );
  }

  void sendAnswer(String answer, int groupId) {
    PatchStatusGroupMembers(userId, groupId, answer).fetch().then((result) {
    });
  }

}