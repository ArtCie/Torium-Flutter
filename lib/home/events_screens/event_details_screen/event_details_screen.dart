import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:torium/api/events/delete_event.dart';

import '../../../api/event_comments/delete_event_comment.dart';
import '../../../api/event_comments/get_event_comments.dart';
import '../../../api/event_comments/post_event_comment.dart';
import '../../../api/event_comments/put_event_comment.dart';
import '../../../api/events/post_notify_all.dart';
import '../../../utils.dart';
import '../../content/comment.dart';
import '../../content/event_details.dart';
import '../../content/member.dart';
import '../edit_event_screens/edit_event_screen.dart';
import 'event_members_screen.dart';

class EventDetailsScreen extends StatefulWidget {
  String userId;
  EventDetails event;

  EventDetailsScreen({super.key, required this.userId, required this.event});

  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  TextEditingController commentController = TextEditingController();
  TextEditingController commentUpdateController = TextEditingController();
  List<Comment> eventComments = [];
  String userMail = "";
  bool isLoaded = false;
  Map<String, String> schedulePeriodMap = {
    "7 days, 0:00:00": "Weekly",
    "30 days, 0:00:00": "Monthly",
    "1 day, 0:00:00": "Daily",
  };


  @override
  void initState() {
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    await GetEventComments(widget.event.id.toString())
        .fetch()
        .then((result) async {
      setState(() {
        eventComments = [];
        for (var comment in result["data"]) {
          eventComments.add(Comment(
              comment["comment"],
              comment["id"].toString(),
              comment["user_id"].toString(),
              comment["event_timestamp"]));
        }
        isLoaded = true;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: DefaultWidgets().buildAppBar(context: context, isProfile: false),
      body: Center(
        child: Stack(children: [
          SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  buildTitleRow(),
                  DefaultWidgets.buildInfoHeader(
                      "Scheduled for ${DateFormat('dd MMM yyyy h:mm a').format(widget.event.datetime)}",
                      top: 0,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                  const SizedBox(height: 10),
                  DefaultWidgets.buildInfoHeader("Group - ${widget.event.groupName}",
                      top: 0, fontSize: 14, fontWeight: FontWeight.w100),
                  const SizedBox(height: 10),
                  widget.event.isBudget
                      ? buildInfoWidget(
                          "Event Budget", Text(widget.event.budget.toString()),
                          trailing: const Text("PLN"))
                      : const SizedBox(height: 0),
                  const SizedBox(height: 10),
                  buildInfoWidget(
                      "Description", Text(widget.event.description)),
                  const SizedBox(height: 10),
                  DefaultWidgets.buildInfoHeader("Invited", fontSize: 15),
                  buildMembersWidget(),
                  DefaultWidgets.buildInfoHeader("Notify", fontSize: 15),
                  widget.event.status == 'admin' ? buildNotifyAllWidget() : const SizedBox(height: 0),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(child: buildInfoWidget("Reminder type", Text(widget.event.reminder))),
                        Expanded(child: buildInfoWidget("Schedule period", Text(schedulePeriodMap[widget.event.schedulePeriod]!)))
                      ]
                  ),
                  DefaultWidgets.buildInfoHeader("Comments"),
                  !isLoaded ? getLoadingScreen() : buildComments(),
                  buildEmptyCard()
                ]),
          ),
          Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [buildCommentInput(context)])
          // child: buildCommentInput(context)
        ]),
      ),
    );
  }

  Padding buildEmptyCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
      child: Card(
        elevation: 4,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Padding buildTitleRow() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 30, 20, 5),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      child: DefaultWidgets.buildHeader(widget.event.name,
                          bottom: 0.0, top: 0.0, alignment: Alignment.centerLeft)
                  ),
                  widget.event.status != 'standard' ? IconButton(icon: const Icon(Icons.edit_rounded, color: Color.fromRGBO(35, 54, 92, 0.5)),
                      constraints: const BoxConstraints(),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EditEventScreen(userId: widget.userId, event: widget.event, userMail: userMail)),
                        ).then((result) {
                          if(result != null) {
                            setState(() {
                              widget.event = result;
                            });
                          }
                        });
                      }) : const Text(""),
                  const SizedBox(width: 10),
                  widget.event.status == 'admin' ? IconButton(icon: const Icon(Icons.delete_forever_rounded, color: Color.fromRGBO(35, 54, 92, 0.5)),
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        QuickAlert.show(
                            context: context,
                            type: QuickAlertType.error,
                            text: 'Do you want to remove ${widget.event.name} event?',
                            confirmBtnText: 'Yes',
                            cancelBtnText: 'No',
                            confirmBtnColor: Colors.red,
                            showCancelBtn: true,
                            onConfirmBtnTap: () {
                              deleteGroup();
                            }
                        );
                      }) : const Text("")
        ],
            )
    );
  }

  deleteGroup(){
      DeleteEvent(widget.userId, widget.event.id).fetch().then((result){
        Navigator.of(context, rootNavigator: true).pop('dialog');
        if(result["status"]["code"] != 200) {
          ScaffoldMessenger.of(context).showSnackBar(
              DefaultWidgets.getErrorSnackBar()
          );
          return;
        }
        Navigator.pop(context, 'delete');
      });
  }

  Padding buildMembersWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Card(
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
                Icon(Icons.groups_rounded, color: Color.fromRGBO(35, 54, 92, 0.5)),
                SizedBox(width: 10),
                Text("Members"),
              ],
            ),
            trailing: const Icon(IconData(0xf8f5,
                fontFamily: 'MaterialIcons', matchTextDirection: true),
                color: Color.fromRGBO(35, 54, 92, 0.5)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        EventMembersScreen(eventMembers: widget.event.users)),
              ).then(onGoBack);
            }),
      ),
    );
  }

  onGoBack(dynamic value) {
    didChangeDependencies();
  }

  buildInfoWidget(String widgetHeader, var title, {trailing: null}) {
    return Column(
      children: [
        DefaultWidgets.buildInfoHeader(widgetHeader, fontSize: 15),
        Card(
          elevation: 4,  // Change this
          shadowColor: Colors.black12,  // Change this
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14.0),
              title: title,
              trailing: trailing,
              onTap: null),
        ),
      ],
    );
  }

  getEventTitle() {
    return Row(children: const [
      Icon(IconData(0xf7c8, fontFamily: 'MaterialIcons'), color: Color.fromRGBO(35, 54, 92, 0.5)),
      SizedBox(width: 10),
      Text('Members')
    ]);
  }

  getEventTrailing() {
    return const Icon(IconData(0xf8f5,
        fontFamily: 'MaterialIcons', matchTextDirection: true), color: Color.fromRGBO(35, 54, 92, 0.5));
  }

  buildNotifyAllWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Card(
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
                Icon(Icons.notification_important_rounded, color: Color.fromRGBO(35, 54, 92, 0.5)),
                SizedBox(width: 10),
                Text("Notify all users"),
              ],
            ),
            trailing: const Icon(IconData(0xf8f5,
                fontFamily: 'MaterialIcons', matchTextDirection: true), color: Color.fromRGBO(35, 54, 92, 0.5)),
            onTap: () async {
              await PostNotifyAll(widget.userId, widget.event.id).fetch().then((result) {
                if (result["status"]["code"] != 200) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("You can send 1 notification per 24 hours")
                      )
                  );
                  return;
                }
              });
            }),
      ),
    );
  }

  ListView buildComments() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: eventComments.length,
      itemBuilder: (_, index) {
        return Card(
          elevation: 4,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 18.0),
              title: Padding(
                padding: const EdgeInsets.only(bottom: 1.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getEmailByUserId(index),
                    const SizedBox(height: 10),
                    Text(eventComments[index].comment)
                  ],
                ),
              ),
              trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(eventComments[index].relativeTime,
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.normal,
                            fontSize: 14)),
                    const SizedBox(height: 10),
                    eventComments[index].userId == widget.userId
                        ? Row(mainAxisSize: MainAxisSize.min, children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              icon: const Icon(Icons.edit_rounded, color: Color.fromRGBO(35, 54, 92, 0.5)),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return editComment(index);
                                  },
                                );
                              },
                            ),
                            const SizedBox(width: 20),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: const Icon(Icons.delete_forever_rounded, color: Color.fromRGBO(35, 54, 92, 0.5)),
                              onPressed: () {
                                deleteComment(index);
                              },
                            )
                          ])
                        : const Text("")
                  ])),
        );
      },
    );
  }

  editComment(int index) {
    commentUpdateController.text = eventComments[index].comment;
    return AlertDialog(
      title: const Text("Update comment"),
      content: TextField(
        onChanged: (value) {
          // setState(() {
          //   commentUpdateController.text = value;
          // });
        },
        controller: commentUpdateController,
      ),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () {
            setState(() {
              Navigator.of(context, rootNavigator: true).pop('dialog');
            });
          },
        ),
        TextButton(
          child: const Text("Continue"),
          onPressed: () {
            updateComment(index);
          },
        ),
      ],
    );
  }

  void updateComment(int index) {
    PutEventComment(eventComments[index].id, widget.userId,
            commentUpdateController.text)
        .fetch()
        .then((result) {
      if (result["status"]["code"] != 200) {
        ScaffoldMessenger.of(context)
            .showSnackBar(DefaultWidgets.getErrorSnackBar());
        return;
      }
      setState(() {
        eventComments[index].comment = commentUpdateController.text;
        Navigator.of(context, rootNavigator: true).pop('dialog');
      });
    });
  }

  deleteComment(int index) {
    DeleteEventComment(widget.userId, int.parse(eventComments[index].id))
        .fetch()
        .then((result) {
      if (result["status"]["code"] != 200) {
        ScaffoldMessenger.of(context)
            .showSnackBar(DefaultWidgets.getErrorSnackBar());
        return;
      }
      setState(() {
        eventComments.removeAt(index);
      });
    });
  }

  Container buildCommentInput(context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
        child: ListTile(
            title: TextFormField(
                controller: commentController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(24.0),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(25.7),
                  ),
                  hintText: "Add comment",
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  filled: true,
                  fillColor: Colors.grey[300],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                }),
            trailing: IconButton(
                icon: const Icon(Icons.arrow_forward_ios, color: Color.fromRGBO(35, 54, 92, 0.5)),
                onPressed: () {
                  postEventComment(commentController.text);
                  commentController.text = "";
                })),
      ),
    );
  }

  Future<void> postEventComment(String text) async {
    await PostEventComment(
            widget.userId.toString(), widget.event.id.toString(), text)
        .fetch()
        .then((result) async {
      setState(() {
        int eventCommentId = result["data"]["events_comments_id"][0];
        eventComments.insert(
            0,
            Comment(text, eventCommentId.toString(), widget.userId.toString(),
                '1s ago'));
      });
    });
  }

  getLoadingScreen() {
    return Center(
        child:
            SpinKitCubeGrid(color: DefaultColors.getDefaultColor(), size: 60));
  }

  getEmailByUserId(index) {
    for (Member user in widget.event.users) {
      if (user.userId.toString() == eventComments[index].userId) {
        if(user.userId.toString() == widget.userId){
          userMail = user.email;
        }
        return Text(user.email,
            style: TextStyle(
                color: Colors.grey[500],
                fontWeight: FontWeight.normal,
                fontSize: 14));
      }
    }
  }
}
