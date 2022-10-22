import '../autentication/amplify.dart';
import '../home/home.dart';
import 'package:flutter/material.dart';
import '../utils.dart';
import '../home/loading_screen.dart';
import '../api/users/get_user_preferences.dart';
import 'package:flutter/services.dart';
import 'preferences_screen.dart';

class ScreenManager extends StatefulWidget {
  String userId = "";
  Scaffold currentPage = LoadingScreen.getScreen();
  Map <String, dynamic> screens = {
    "null": 1,
  };
  Map<dynamic, dynamic> data = {};

  ScreenManager({super.key});

  @override
  _ScreenManagerState createState() => _ScreenManagerState();
}

class _ScreenManagerState extends State<ScreenManager> {
  _ScreenManagerState();

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    widget.userId = (await AmplifyConfigure.getUserId())!;
    getUserPreferences().then((data) {
      setState(() {
        data["data"]["reminder_preferences"] == null?
        Navigator.pushReplacementNamed(context, '/preferences')
            : Navigator.pushReplacementNamed(context, '/home', arguments: {'userId': widget.userId});
      });
    });
  }

  Future<Map> getUserPreferences() async {
    GetUserPreferences getUserPreferences = GetUserPreferences(widget.userId);
    Map<dynamic, dynamic> fetchedData = await getUserPreferences.fetch();
    return fetchedData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: widget.currentPage),
    );
  }
}
